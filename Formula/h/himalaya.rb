class Himalaya < Formula
  desc "CLI email client written in Rust"
  homepage "https://pimalaya.org/himalaya/"
  url "https://github.com/soywod/himalaya/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "9a5593a3a92dcce8227cea45870a88432d8df3a012636eb5461165cf599dbcbb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3ab0c354fca08ffd2904271e563515d0efe3b7e1b9d57188b673199b167dccb3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "738f75aedd57528d9db730056b4f0113a040769a166f3867abf9280b3d61c870"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "669e214ec347274c3c3307c70707018878dc5badfb225a2474bdb1222480c1a5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c2fae94407f6ed9a3219ad2b48c7ed988298447ada49c59a4afa758fc727eecf"
    sha256 cellar: :any_skip_relocation, sonoma:         "4c0ae039e35eebee9f19987c947ad65efe169d0785aa64bdd0f7798102223c38"
    sha256 cellar: :any_skip_relocation, ventura:        "83bb99ef9a793f8bd75e124e002d9e5f0fbda01292b69efee8b50169a57b5a7d"
    sha256 cellar: :any_skip_relocation, monterey:       "f79d8bc1dcce9339d6629f14b7f3fe83bb2ad83981e39307e25876d68ef5e72a"
    sha256 cellar: :any_skip_relocation, big_sur:        "058bf1827a10ac97c86c9760da9943ca7e282328c81605568334d4c1a13053ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d7452aa05f8a359c8c0f4accba2a48a9625b98a368dd48f9c5845c066d5c112"
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
      imap-auth  = "passwd"
      imap-passwd = { cmd = "echo password" }

      sender = "smtp"
      smtp-host = "smtp.gmail.com"
      smtp-port = 465
      smtp-login = "your.email@gmail.com"
      smtp-auth  = "passwd"
      smtp-passwd = { cmd = "echo password" }
    EOS

    assert_match "Error: cannot login to imap server", shell_output(bin/"himalaya 2>&1", 1)
  end
end
