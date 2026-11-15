class Himalaya < Formula
  desc "CLI email client written in Rust"
  homepage "https://pimalaya.org"
  url "https://github.com/pimalaya/himalaya/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "261b6d3bce4f0de6399b347525fc3c687f309d83840b4e10a58ab7ad70c03544"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f0fce62956ad39ea76c99df35da0e3301360686a056e57d5c09e89cb8cf48a0c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "86cb65a5f5969464e2bf9a8f0ebb8104dd54f0fd758ad2a62d5811f97a8273dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "76662dea6fd548a0ef1fcd53837ee76614420212181d15b2d1d1abfa5b7c4dfc"
    sha256 cellar: :any,                 arm64_linux:       "f4c7254c48119c47597734987681d23027c3213a6ce9b3edee983bda09c0df64"
    sha256 cellar: :any,                 x86_64_linux:      "4f371b48ca6debc1323bc92ad83da357cf031b93e918771bef33b39f473bb71e"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    system bin/"himalaya", "manual", "--dir", buildpath
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

    assert_match "gmail", shell_output("#{bin}/himalaya account list")
  end
end
