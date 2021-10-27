class Himalaya < Formula
  desc "CLI email client written in Rust"
  homepage "https://github.com/soywod/himalaya"
  url "https://github.com/soywod/himalaya/archive/v0.5.1.tar.gz"
  sha256 "13567726903243f04a4aa64e96b88e0d0fd5c3ccbe4953357f3a8ef1c569dad9"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d89a9bf558bdd09234e2291f533ef7624fa81d17adc828358bbed18aef861378"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b0c3660ccba1c8e963fde7868c2988bc14bccf31085f73f32a64dfaac04e8cd2"
    sha256 cellar: :any_skip_relocation, monterey:       "887d9d994ee1872f9bc8a8c25693ea42b8a85c713719f70ee6af8cf196609b0f"
    sha256 cellar: :any_skip_relocation, big_sur:        "db1315d616ab86550f596947fe09d87dfd7584a8cdc947f95e44dffe8a4c4002"
    sha256 cellar: :any_skip_relocation, catalina:       "238d680a288267b1002c9cab1ef339ac6f12caa1f1f236a49d2323ce8dff33a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58e32176b2da5bc28e56e3711892d822066c0f1e5f2de6239419d8329cb96271"
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
