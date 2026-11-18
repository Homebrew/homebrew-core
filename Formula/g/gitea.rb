class Gitea < Formula
  desc "Painless self-hosted all-in-one software development service"
  homepage "https://about.gitea.com/"
  url "https://dl.gitea.com/gitea/28.4.0/gitea-src-28.4.0.tar.gz"
  sha256 "321fb8217c86ac7f41f60214e455c695b9c5382a514c8b40dd7ca20908f22b3f"
  license "MIT"

  livecheck do
    url "https://dl.gitea.com/gitea/version.json"
    strategy :json do |json|
      json.dig("latest", "version")
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c77d836b07f0ef212737da6e8647a2a863b1dc3f304c605c694f3e1f3ff26805"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "82352dfc5a4e67dc180f48588c2a16b26231694a21e71a4408cbdd6337c32f27"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "03e0bed5292292371875d1a81566fdb507331e7b0377f66479720047bdab5777"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a4f89c7c836fc65a7294ce2888307ddd6b748bfe4626a852bbc290d3d6460581"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "c332e85c63b370478997cff45cf634786b3af7a2e0b7e64f5fe84ee4df3002ec"
  end

  head do
    url "https://github.com/go-gitea/gitea.git", branch: "main"

    depends_on "node" => :build
    depends_on "pnpm" => :build
  end

  depends_on "go" => :build

  uses_from_macos "sqlite"

  allow_network_access! :test

  def install
    ENV["TAGS"] = "bindata sqlite sqlite_unlock_notify"
    system "make", "build"
    bin.install "gitea"
    system bin/"gitea", "docs", "--man", "-o", "gitea.1"
    man1.install "gitea.1"
    generate_completions_from_executable(bin/"gitea", shell_parameter_format: :cobra, shells: [:bash, :fish, :zsh])
  end

  service do
    run [opt_bin/"gitea", "web", "--work-path", var/"gitea"]
    keep_alive true
    log_path var/"log/gitea.log"
    error_log_path var/"log/gitea.log"
  end

  test do
    ENV["GITEA_WORK_DIR"] = testpath
    port = free_port

    with_test_process(bin/"gitea", "web", "--port", port.to_s, "--install-port", port.to_s) do
      output = shell_output("curl --silent --retry 5 --retry-connrefused http://localhost:#{port}/api/settings/api")
      assert_match "Go to default page", output

      output = shell_output("curl -s http://localhost:#{port}/")
      assert_match "Installation - Gitea: Git with a cup of tea", output

      assert_match version.to_s, shell_output("#{bin}/gitea -v")
    end
  end
end
