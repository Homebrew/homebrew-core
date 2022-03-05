class Himalaya < Formula
  desc "CLI email client written in Rust"
  homepage "https://github.com/soywod/himalaya"
  url "https://github.com/soywod/himalaya/archive/v0.5.8.tar.gz"
  sha256 "c7b6c63f22a7a8b06f195f7da8bf1de715eab20220a5a5278ee9c533e8a2d505"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e2f9656c91a64d36cbe62490e80550370d894d7816c2364e7a1a46fa4391301"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e8da868dda620de0b3b598f08dba318396a8c5090af4f18a3aba4ccceea1d854"
    sha256 cellar: :any_skip_relocation, monterey:       "79038ad264c996afd4e20cb7cf046ea68f5c78f524bfe408e2d4c62064831d31"
    sha256 cellar: :any_skip_relocation, big_sur:        "ac50ca4ef532ba795e1be49f764c51c92a9cf847068b47962d7c59b0389fb294"
    sha256 cellar: :any_skip_relocation, catalina:       "a775ea39a296df5be9761eff55aefc6a61defc2bf2bbd25a59c4b79589c4b9cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e813a7d5c3c3892dfad92630f7bd9409378ca107e2915b47e58cd556f0cbf6e"
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
