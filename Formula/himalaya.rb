class Himalaya < Formula
  desc "CLI email client written in Rust"
  homepage "https://github.com/soywod/himalaya"
  url "https://github.com/soywod/himalaya/archive/v0.5.10.tar.gz"
  sha256 "2922b60caa37de70464a11df44704d8b5589f6d968532350267ffb136da54cbd"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f79c68e2de9f330e5427667579d5a06069d2ac78c11cf17d8fc6c58ed84c245"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0580507f20d92823da2dead3f50b79a2422798d722bc9cb61b14065dc729a6e6"
    sha256 cellar: :any_skip_relocation, monterey:       "b3030bd5441677908fe7bad4109a386fc0a69b3a2e9432ab708d8a4c63c31a52"
    sha256 cellar: :any_skip_relocation, big_sur:        "d5df4a1659260bc435c8f4a58e801b917c92546d9ca9fa2c88de54648a434c5b"
    sha256 cellar: :any_skip_relocation, catalina:       "096db06d6c52b67d64d352d031c347ccf71a13132bed878170dce35fc98e80c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97dce2aaa3825826dda3b08dc795bdafa4b607ac741d94d8e4b251a987eb1d61"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
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
