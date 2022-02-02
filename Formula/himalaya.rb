class Himalaya < Formula
  desc "CLI email client written in Rust"
  homepage "https://github.com/soywod/himalaya"
  url "https://github.com/soywod/himalaya/archive/v0.5.2.tar.gz"
  sha256 "4de18f908e08d562f3b765a61225467588d23d1c9a72710025a6c648034729ef"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "21c5c1ff373c3a7fb4d7fcef1f064023566e95e2f6b174a97c6fe8fd734c7540"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2bd3e1469fa2ddea0e192ef2da08dab4880afc3b3b03804243b17dd0759a81cb"
    sha256 cellar: :any_skip_relocation, monterey:       "ec639f53bf5e8acf1d602f412f8aa5953d4f51831c95a86a431f90f1f35aac48"
    sha256 cellar: :any_skip_relocation, big_sur:        "e9a537247fa2adc5a4dfcebeb02176d3efc588a72ac507a9f2347ef0ad95eada"
    sha256 cellar: :any_skip_relocation, catalina:       "07974133842d04c2195ba095f19ef476709ff6b9822ea66986526ec89c018364"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b6e1224f86fbcb1833110fdd23091201bbd483a1a69829da34d9e1b950f6fbe"
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
