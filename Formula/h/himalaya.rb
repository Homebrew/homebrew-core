class Himalaya < Formula
  desc "CLI email client written in Rust"
  homepage "https://github.com/pimalaya/himalaya"
  url "https://github.com/pimalaya/himalaya/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "3d04afdf6f753219c2203feb8094a2ec82c77bab7f9acbe1811773e2a4562877"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e1375ecd904d222cde2932a96620b405074f6a478441e21709a81183b873499e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ccf165d1e218a8146995cbe7ccc33f39128b2cc9eeacd24f7b2d186df8303f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb6882e8b3b147600931627d740784d9f45a194202d2c2ca89ded9fbf5edd5ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "54440c8555788e20be0b89d3e13d1dbc763a83ae86a103a8356f3106ff474ea6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a098e3f2bc26c7c138b7f0d6f44696859d17fdad9fde7f405713c2cb76f8ce8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "584bd8c006a35b6ee48d9783da040152948df2e3d26132c329c75eef05c506ca"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args

    system bin/"himalaya", "man", buildpath
    man1.install Dir["*.1"]
    generate_completions_from_executable(bin/"himalaya", "completion")
  end

  test do
    # See https://github.com/pimalaya/himalaya#configuration
    (testpath/".config/himalaya/config.toml").write <<~TOML
      [accounts.gmail]
      default = true
      email = "example@gmail.com"

      folder.alias.inbox = "INBOX"
      folder.alias.sent = "[Gmail]/Sent Mail"
      folder.alias.drafts = "[Gmail]/Drafts"
      folder.alias.trash = "[Gmail]/Trash"

      backend.type = "imap"
      backend.host = "imap.gmail.com"
      backend.port = 993
      backend.login = "example@gmail.com"
      backend.auth.type = "password"
      backend.auth.raw = "*****"

      message.send.backend.type = "smtp"
      message.send.backend.host = "smtp.gmail.com"
      message.send.backend.port = 465
      message.send.backend.login = "example@gmail.com"
      message.send.backend.auth.type = "password"
      message.send.backend.auth.cmd = "*****"
    TOML

    assert_match "cannot authenticate to IMAP server", shell_output("#{bin}/himalaya 2>&1", 1)
  end
end
