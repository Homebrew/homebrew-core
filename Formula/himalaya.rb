class Himalaya < Formula
  desc "CLI email client written in Rust"
  homepage "https://github.com/soywod/himalaya"
  url "https://github.com/soywod/himalaya/archive/v0.6.1.tar.gz"
  sha256 "e0627eab2758b470051309e4c60bd4e2b0b22cc7a4d6810d94d629648a06d81e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec83b9316ed44327e38ec8b776da6a33218962ca65bcc163ffeafd80ab88d7fe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "23c8e50bc317091ba0672b0ba132800416e461851736c2ac928752f6f6f524ec"
    sha256 cellar: :any_skip_relocation, monterey:       "08bce1d10fa2c42fb562e0c6e2ce5110210332db9fad4240832b8e072f2ba912"
    sha256 cellar: :any_skip_relocation, big_sur:        "fad21c3f7431609d1dfe9368c3d8466d13bc93476b8d24bdd5a1c38f6de9d7b8"
    sha256 cellar: :any_skip_relocation, catalina:       "9ddd5b1f6ac7cd939a5a9861d8dcbefefd537e8917903f4ed62728c77b48a91b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "240f5c2013ae749b60ea15b2d9c5d12a3177ec692d710297da4944a7534018d3"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
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

      backend = "imap"
      imap-host = "imap.gmail.com"
      imap-port = 993
      imap-login = "your.email@gmail.com"
      imap-passwd-cmd = "pass show gmail"

      sender = "smtp"
      smtp-host = "smtp.gmail.com"
      smtp-port = 465
      smtp-login = "your.email@gmail.com"
      smtp-passwd-cmd = "security find-internet-password -gs gmail -w"
    EOS

    assert_match "Error: cannot get imap password: password is empty", shell_output("#{bin}/himalaya 2>&1", 1)
  end
end
