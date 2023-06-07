class Himalaya < Formula
  desc "CLI email client written in Rust"
  homepage "https://pimalaya.org/himalaya/"
  url "https://github.com/soywod/himalaya/archive/v0.8.0.tar.gz"
  sha256 "c9bf62c802b05d3c98e105513042eafbbcbed4c5ed61aec7addae185accc5b40"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a106821ad8ac1a398f2f06a1b694874a12143330c319e49f8b7fd14c2878fff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4332673b3e739f709f691f484c0650f2f53191c7da05830295ac8bf70a150313"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3b72caab5bbcff703bc746a92ca7af8c9b6ac858e73623ae25ffef512627fa80"
    sha256 cellar: :any_skip_relocation, ventura:        "336d88072ee281dc06862a5d1763c986e62bbfdb4995834d25f4e36b3c8ddc46"
    sha256 cellar: :any_skip_relocation, monterey:       "7ab02e1d0b86dbd4ed7d6773335d234028864df4e669787e5f1fd0c646ad2a51"
    sha256 cellar: :any_skip_relocation, big_sur:        "27d7f2bc3b56ef69081052e6bf177c5b5ac035d784f5cc93abc6fa5fe100c4a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81585e75f83cadb692e56cae5475d7574107e215f6c3e47105da9c0a906f744b"
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
