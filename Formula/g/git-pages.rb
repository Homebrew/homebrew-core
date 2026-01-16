class GitPages < Formula
  desc "Scalable static site server for Git forges"
  homepage "https://codeberg.org/git-pages/git-pages"
  url "https://codeberg.org/git-pages/git-pages/archive/v0.3.1.tar.gz"
  sha256 "1debdbbd101fe156ffe1ba8c679946165217005366b9c212427d1a91dfa6ed76"
  license "0BSD"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1d0772dec80e3adfa342115c12c2a14463140f59a6feb05e46f8989872553a5a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb384f6f3305ad4596d97880100bf42dd80ff8095ffdeae2dea3ac44d452875c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "563234deb9be40543f0baf209a22f72a2300afd0591e5190bf40843b620f70f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "bccdc1efdd9c410ca7477d257962f9d030dfbe23a55eff30e6509482d821d936"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "efb638a555544adfad44e35679b7b73a89443a44c7c52c7eb3167eea34b9944c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94bef86aa93db3dbcd770bfdf0d2e8faf090072d68d63a8d0483a8acb7d483b3"
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
