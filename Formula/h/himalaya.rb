class Himalaya < Formula
  desc "CLI email client written in Rust"
  homepage "https://github.com/pimalaya/himalaya"
  url "https://github.com/pimalaya/himalaya/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "bc5ee10ebdb23ea205215650070373dc591f083a96b1d6d038aa23a105256f94"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c087617ce4bda639baba803d8bad64237424b2bcfb7ea733267a510d1ebc731"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4faaa05c76bc7dd4d2423479e34af0cff58aba3f95bcd5a96ee6b154326460d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9194d490d1c2356183427ebe2762a813661535944d34daa63e2d75d976ef6bbd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0ef6045f2bf47e807661cf800ff036e9df0c2e99fcea5e7d00ba0bed15a0160e"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2782ddbd515580d4ce47d939155d31b3bf744500ef566c771d839bc32b05f5f"
    sha256 cellar: :any_skip_relocation, ventura:       "159ef73b0f7b1fbca6cd8a509a993b7d18df156eddce6b04ad5e22360343d35f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84fa7f497a0ad4b0538f9891058ed21051e906a48fcd2dbef55aa49cad570f28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b564756c788cadcae7e27532be8008896bf3cf742c7b5f9c861f966576364df4"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  # revert `cc` crate to 1.2.7, upstream pr ref, https://github.com/pimalaya/himalaya/pull/542
  patch do
    url "https://github.com/pimalaya/himalaya/commit/ea70e7c123fd8b30e5b36ab62bfcfafa63779797.patch?full_index=1"
    sha256 "44e8c415819272971787761f285be397ddc384a4230890bf1c8494c786b45373"
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
