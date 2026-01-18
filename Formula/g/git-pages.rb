class GitPages < Formula
  desc "Scalable static site server for Git forges"
  homepage "https://codeberg.org/git-pages/git-pages"
  url "https://codeberg.org/git-pages/git-pages/archive/v0.4.0.tar.gz"
  sha256 "e75c373858e28e5e38307dc85ade51ad668c6ba64f49bfad94a85d2fb7d09d4e"
  license "0BSD"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0f743854760ec54d3f2453a41416fa47fff3c7e74867f10833f8e6544e838b21"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a01498f156a2d2f03ebb9ed237336b1b6a2ca0150d97b11e9ec922290dd70e54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6161421a0d4473b6c4d048d2f8eaef85639b55cbc53a3c30e89b0ae3e72f7c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b61791a7c4d861b30d77c6f6efb8c5abd541cc5b85b524ef83b06199e49c566"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52b23955bfc195e6d92b4e52f34def2834b437f2969ae2e53385f2f4bc4eadff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "409c29c9968f7166bf5ae8ae239fd8aea6ad96c0f24a1a226db84c3a3128c391"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    mkdir_p "data"
    port = free_port

    (testpath/"config.toml").write <<~TOML
      [server]
      pages = "tcp/localhost:#{port}"
    TOML

    ENV["PAGES_INSECURE"] = "1"

    spawn bin/"git-pages"

    sleep 2
    system "curl", "http://127.0.0.1:#{port}", "-X", "PUT", "-d", "https://codeberg.org/git-pages/git-pages.git"

    sleep 2
    assert_equal "It works!\n", shell_output("curl http://127.0.0.1:#{port}")
  end
end
