class Himalaya < Formula
  desc "CLI email client written in Rust"
  homepage "https://github.com/soywod/himalaya"
  url "https://github.com/soywod/himalaya/archive/v0.7.1.tar.gz"
  sha256 "79ad75e765a5298c5c597beb175cec1d2982eead2172bc78daa7a9f159c99861"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "415a21495788fd92d2907cea2420154565b455e04dbf7b0bbd1375677475f566"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c0fbdae8f21ebeb156a3f9af963f8d821f97441385cc6314129b64f3db4249c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0ecc797a85f72d03f9ebc11ecf8a51c3f06b86de58d62d0659814460349508e1"
    sha256 cellar: :any_skip_relocation, ventura:        "fef11ce5024a488a4cb2be00f850746d21048090ccc379114b946fe99b373979"
    sha256 cellar: :any_skip_relocation, monterey:       "96a977466b88e9c89b6a0d2ea8ba3742f769f4effaa9026082cfb82e4bddd82c"
    sha256 cellar: :any_skip_relocation, big_sur:        "859b1d2ad47a92f11724ca75b981ff43c33a362a19370f045a9adf837f93119b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "471525f826d9196f49ccc7efdea116cc102cb175f8f19cb910b8a5ec3a3a6e8e"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"himalaya", "completion")
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
