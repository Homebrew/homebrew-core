class GitPages < Formula
  desc "Scalable static site server for Git forges"
  homepage "https://codeberg.org/git-pages/git-pages"
  url "https://codeberg.org/git-pages/git-pages/archive/v0.6.1.tar.gz"
  sha256 "ccbca448e7802f0872c069262a2e6a3e3151bab75db50ce938e67bfbc24bc99c"
  license "0BSD"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "08be4a76de4658e9a68ec241e6399ce0ae07224e5e629c93da528a3aca9d4630"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "176686286d8ab4909797e622631a5fa5fa46dcf71cba26c539ed32d55105071a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f24bf7365a5a83c47fc62f37478d6210c64679df3c719a9f797b156d1e6d1077"
    sha256 cellar: :any_skip_relocation, sonoma:        "4edfeb7914a073a8e4dfdee0bab6b2e48b2b873cd459547612cc7760942c51f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6025722284e9361a57ac5f472c1bdac24ea2f121a4dad12d5a46c64ec57c260c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9d5da2cd925a3b88a62e4ce95ded7867a2324b083ac95852e75fc6f00498767"
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
