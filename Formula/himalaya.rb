class Himalaya < Formula
  desc "CLI email client written in Rust"
  homepage "https://github.com/soywod/himalaya"
  url "https://github.com/soywod/himalaya/archive/v0.6.0.tar.gz"
  sha256 "b9d88506de8b00ce5c80981f19989b2da062c80f8b35a70c60d349e51628cbb7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff6ee45d34052bdba6d8da86f2f0e3251cf74fd2ad18ea7f0254e166311bfe54"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fcaa547be65906a98ec560fef65213f3dbd4ec6598927a27b4334ccc05db7c4a"
    sha256 cellar: :any_skip_relocation, monterey:       "dbcb6e9b30553dd5e065021ac668bb4c1717ec35d240629e7d73727bb7fc4e75"
    sha256 cellar: :any_skip_relocation, big_sur:        "025f5ff6ea9df1b3ca941c4b7f6ed56981d6c600b0ec33918ae6fdfba00d8a0e"
    sha256 cellar: :any_skip_relocation, catalina:       "2bd1d8dd88fff95258d007ed887fb1ac6e1fad297f7858ac73934e6f0059aa25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ff18edde049c95b4111b02c5755b30cb8245fa42209a32d0fdb8005094d1cad"
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

      backend = "imap"
      imap-host = "imap.gmail.com"
      imap-port = 993
      imap-login = "your.email@gmail.com"
      imap-passwd-cmd = "pass show gmail"

      sender = "smtp"
      smtp-host = "smtp.gmail.com"
      smtp-port = 465
      smtp-login = "your.email@gmail.com"
      smtp-passwd-cmd = "security find-internet-password -gs gmail -w"
    EOS

    assert_match "Error: cannot get imap password: password is empty", shell_output("#{bin}/himalaya 2>&1", 1)
  end
end
