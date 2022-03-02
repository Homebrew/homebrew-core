class Himalaya < Formula
  desc "CLI email client written in Rust"
  homepage "https://github.com/soywod/himalaya"
  url "https://github.com/soywod/himalaya/archive/v0.5.7.tar.gz"
  sha256 "7bdcf140401aaefd5bf6b639c44124169c5e4d738ed5097dbc8f24b3e4726a91"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fdfe6b8e75c650c35ecad06df3a8b65e26931886b4f999df4500b9ececeb98af"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9e9bbb8d3795732599a2bb1f2f79dc987b0c589418ee858658b739fe9b1b0a5c"
    sha256 cellar: :any_skip_relocation, monterey:       "d7e4dd903667b64ee53526baa4d487ac9b05dbb704458231ec67616d1b7e04b1"
    sha256 cellar: :any_skip_relocation, big_sur:        "8b5904995f185028a48daddf1671b36cb83fa9cc39d6e8994e70a75f4c40e3c1"
    sha256 cellar: :any_skip_relocation, catalina:       "e6f44f83c01ffc4e6365f2e0f71a313624abc2294bc679211009209294256ebd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6f25ca9c9039242270ca640b9609baf194a8aec54ebe1fbda1d3beb5e2088e3"
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
