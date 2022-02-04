class Himalaya < Formula
  desc "CLI email client written in Rust"
  homepage "https://github.com/soywod/himalaya"
  url "https://github.com/soywod/himalaya/archive/v0.5.3.tar.gz"
  sha256 "743f8ec9ebe382b807ada94680724ca244790a0b117ccd537d131338b8b149b4"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ff9a79fbb4900a769192e91b640f86288d1a7f030e705b658872f7e83054920"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1be791cfdabe7ab8f0b01e8aee74ade18d30cb03834eccd5c123c38c742ac915"
    sha256 cellar: :any_skip_relocation, monterey:       "84124234488222c78c32f35ad0e6b4ff1fec300760045fb2b0db162331788ae2"
    sha256 cellar: :any_skip_relocation, big_sur:        "661f349b80596adcbf8bdbc40339ec0039615982f5a8235f4e2dd09f6bdef5e6"
    sha256 cellar: :any_skip_relocation, catalina:       "5d9bb8f1751cac45aa74bebd38697a5e67648907e4e958b2086e5c4d66c879e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2dc8d76f1ae4ef652da4cc8003c41987151756a3a09811896c27f0c6e66a0223"
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
