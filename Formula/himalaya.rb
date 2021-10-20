class Himalaya < Formula
  desc "CLI email client written in Rust"
  homepage "https://github.com/soywod/himalaya"
  url "https://github.com/soywod/himalaya/archive/v0.5.0.tar.gz"
  sha256 "9ac8828f476f7b91ead4598237aa0e46a782327ef8f3d1ab6d7db75eb928173a"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f4d5f0bfbea959ce2c1ec28eb7390d6aaeb10142b49b5d6c6fbd924a5e2d4b8b"
    sha256 cellar: :any_skip_relocation, big_sur:       "add65bf60e94df3070afbfc47762c124110105d46bce5b623addb50c48b761ce"
    sha256 cellar: :any_skip_relocation, catalina:      "dc9d1dbdf992d95748c7a1e968adab904b0d347bb9d9a3c3c74e91c2f8830bf9"
    sha256 cellar: :any_skip_relocation, mojave:        "a3026d947c691e9df9559fd31a75dc0f5d7ed5b8c578556505b3cdffd0e3766d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0612ac59172e8b4884ab9c3038d9a0d1aaf1e2807f4a9892654d1bb02286b83"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # See https://github.com/soywod/himalaya#configuration
    (testpath/".config/himalaya/config.toml").write <<~EOS
      name = "Your full name"
      downloads-dir = "/abs/path/to/downloads"
      signature = """
      --
      Regards,
      """

      [gmail]
      default = true
      email = "your.email@gmail.com"

      imap-host = "imap.gmail.com"
      imap-port = 993
      imap-login = "your.email@gmail.com"
      imap-passwd-cmd = "pass show gmail"

      smtp-host = "smtp.gmail.com"
      smtp-port = 465
      smtp-login = "your.email@gmail.com"
      smtp-passwd-cmd = "security find-internet-password -gs gmail -w"
    EOS

    assert_match "Error: cannot login to IMAP server", shell_output("#{bin}/himalaya 2>&1", 1)
  end
end
