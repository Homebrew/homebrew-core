class Himalaya < Formula
  desc "CLI email client written in Rust"
  homepage "https://github.com/soywod/himalaya"
  url "https://github.com/soywod/himalaya/archive/v0.6.1.tar.gz"
  sha256 "e0627eab2758b470051309e4c60bd4e2b0b22cc7a4d6810d94d629648a06d81e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "228423705be7125f89466fbc1a402b59a11a42fe3e5733da3a2008ec2e65eea6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b3c895ac97e696cd8e72540cf1b35ae67a640d51eedb602283ffba7a06150237"
    sha256 cellar: :any_skip_relocation, monterey:       "e55224ee1eaf81ebe35e45cae4d298f21b59e94eb2b186aabd43105543724901"
    sha256 cellar: :any_skip_relocation, big_sur:        "888d0a5f2329ff1886873fbd1ebfce5e2ffd75b10bfdbff6f23c689f5437ca08"
    sha256 cellar: :any_skip_relocation, catalina:       "59d725336736c13e371f3122914aa00554f0be6571b31f0986f6282c560088f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df944a8eac04538217530966bdb4ff7f2becf551af52a2fb88f229cb272eb485"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
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
