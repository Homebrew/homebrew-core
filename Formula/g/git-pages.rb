class GitPages < Formula
  desc "Scalable static site server for Git forges"
  homepage "https://codeberg.org/git-pages/git-pages"
  url "https://codeberg.org/git-pages/git-pages/releases/download/v0.10.2/git-pages-src.zip"
  sha256 "bfbb4cd1e5481a051cc513ad1c0a1e9e6220f2403fe9f1311cd1207404aeed3d"
  license "0BSD"

  bottle do
    manifest_sha256 "f4cf7e5390d0ff98ae033ae5380157a1584eddc8f34db16d61a4f3fefcbbcf90"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "717c370e16c4efe09430e51cd36f88c817182040eb687568aa6f65d491298f0a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f5160ebff8ff66dfd775a0df289088f8438d6dbb2c9855653ec85f3a2c52bdeb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a3346850520b2df6657e39d99a4abc9a1eedea8181c52559cf136bb24aecf82d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3de65f0cbec5e0f657719e2214e02f5cf938f68a0b91029997a014e4b714f20d"
    sha256 cellar: :any,                 x86_64_linux:      "2cff6a7e94b7850e264d3848c8b2bfbc0d188018b07018df9d1e9c7f2d3fc37d"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args
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
