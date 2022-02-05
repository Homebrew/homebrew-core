class Himalaya < Formula
  desc "CLI email client written in Rust"
  homepage "https://github.com/soywod/himalaya"
  url "https://github.com/soywod/himalaya/archive/v0.5.4.tar.gz"
  sha256 "48d7444789b5775036985a9ce4060005bc0329f90a4c8eb8a7169702fe2210c0"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "647d428038d29193459f4cd670655928de39f2da7b040ff9e540f390be95e612"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f0a8649d857103d7c8fbb38278965d2a84bce1ed57bed4e2668b62c1d05526a6"
    sha256 cellar: :any_skip_relocation, monterey:       "6bedaade214d816e6d10e0eeb7b647687fd4815c42d55da22fdaa715c9657b33"
    sha256 cellar: :any_skip_relocation, big_sur:        "241f141d3cfe93febb3879093704446a00a60d9f8c5edeea519d96db62ec4131"
    sha256 cellar: :any_skip_relocation, catalina:       "40a338b7e4df8faaffd2af3e77be0b623e2e5ba0ecaa39d11917f441bd006869"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b6f6d186314402855feac3a6a33d785db721b71d54761e18aa773a72d79d938"
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
