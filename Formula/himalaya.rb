class Himalaya < Formula
  desc "CLI email client written in Rust"
  homepage "https://github.com/soywod/himalaya"
  url "https://github.com/soywod/himalaya/archive/v0.5.5.tar.gz"
  sha256 "cd83b2c5d43edae18cc6bcfcd32e0b7afe711d96ad743eccb48133e19b67504b"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e1fdea7dc5b590796a1d773727c84f95432b5e15336d9fa8231af14bbf408c4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b0db2b25a7cbd96f0683325a6f1a2457783dc08a9157ebf39d3b66048e903db1"
    sha256 cellar: :any_skip_relocation, monterey:       "1a07648c4f99312d25bccc37f1d5c9d67946bd3cbfaf5d793e44edd39c091749"
    sha256 cellar: :any_skip_relocation, big_sur:        "049be660f6ef56e0bd25a9c703ac9e9fd54e0dd69f44fef8b493a9d5c920b45c"
    sha256 cellar: :any_skip_relocation, catalina:       "8b1623653d54d94d392cb71e509b9ee000366ef7a55bf994bb78589730127b74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "857ff8b134bccb418fb4df60f1efdd5525457666bf709ff14945fc0136f2c975"
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
