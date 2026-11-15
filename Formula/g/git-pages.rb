class GitPages < Formula
  desc "Scalable static site server for Git forges"
  homepage "https://codeberg.org/git-pages/git-pages"
  url "https://codeberg.org/git-pages/git-pages/releases/download/v0.10.1/git-pages-src.zip"
  sha256 "d9a06bc1801a4f88302ecd96452238974c05ff17b06532c0a97671b47cd7bb27"
  license "0BSD"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1c0beaddd2629285579286eded99dee551ac711f3c65df2719471d274c236f8d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "83910ef499b764521b16b2cfab948a5be6643bb9a9e933e6198e40e262c6b392"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fdf7b0768261543e003c4b3ad38bc1d9d5d44a8be5128b074cc500f5bf34811e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2ccea151aa99ced2eeafbae36cf261f4c62563b926c17be0c125c671d5e2c997"
    sha256 cellar: :any,                 x86_64_linux:      "13fe3e6ce5af4725a2ff4603f4afd9016d3905b8a35654e04374a58f6e6635b3"
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
