class Himalaya < Formula
  desc "CLI email client written in Rust"
  homepage "https://pimalaya.org"
  url "https://github.com/pimalaya/himalaya/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "491c7e51aa58874e2b70b4a0377e1770a1d3522392b9a9b867f965ac9d75aaa5"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bf93247c63b1452a46d4dd5cef349a422116c41d7523b3715d7df715156c0b37"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a49034e4c13c93092c494ff52ed5469371a087e41c7c9e8aae5621b82085fbb1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8bd69f718b12a0a0f23239cd4b858e8c4f3be8811f9b822ca8b7a9a4ba8fbc7"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f7b50b2533d2638842096a32c3c24360fed668fb43894e52a826304c9b5702d"
    sha256 cellar: :any,                 arm64_linux:   "8638c2ba2f083f0b76448dfd647c55c2910529f652d40d4ad1f7694422f374b3"
    sha256 cellar: :any,                 x86_64_linux:  "e7406de7206ff4bb320b73bc72b401b524b1a57af4143228b2262cbdf4cd0e19"
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
    system bin/"himalaya", "completion", "bash", "fish", "zsh", "--dir", buildpath
    bash_completion.install "himalaya.bash" => "himalaya"
    fish_completion.install "himalaya.fish"
    zsh_completion.install "_himalaya"
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

    assert_match "gmail", shell_output("#{bin}/himalaya account list")
  end
end
