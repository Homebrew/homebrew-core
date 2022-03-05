class Himalaya < Formula
  desc "CLI email client written in Rust"
  homepage "https://github.com/soywod/himalaya"
  url "https://github.com/soywod/himalaya/archive/v0.5.8.tar.gz"
  sha256 "c7b6c63f22a7a8b06f195f7da8bf1de715eab20220a5a5278ee9c533e8a2d505"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "877457c2c063dfa79abe009f2ba885f15a10f193f660757c4d862b27aa435805"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5f96f874f444a18847bb3d1c41bbbc7c7a9b92c05183f6be36a3540dce96f28a"
    sha256 cellar: :any_skip_relocation, monterey:       "0de7b2dad53500d8d77b7deabace31a0a4cb5efaa699ec16b3ba9aa52466c99b"
    sha256 cellar: :any_skip_relocation, big_sur:        "3eb630b4afc00e992a99b9be1747f223e27967935baf88fabadfd5e9baab4bbb"
    sha256 cellar: :any_skip_relocation, catalina:       "8f5cc59d431359a486e18d66a6164ce23499613d4ef6fa4d2a824a8a8b83cbe2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1290e45bec0825d8c5478a07b30e302f52efab362c69643984010a037996e8f7"
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
