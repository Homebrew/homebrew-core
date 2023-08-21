class Himalaya < Formula
  desc "CLI email client written in Rust"
  homepage "https://pimalaya.org/himalaya/"
  url "https://github.com/soywod/himalaya/archive/v0.8.4.tar.gz"
  sha256 "61f0535c37baac58a6cae8e793fd8d9be84ab47d74e69bdc3cf43e5676e6cb6d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e8a47d949b8d48ab0de7ed9752242ed99727eb45deaed4e1a7bdc39b3cb94a8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6cca94538b01a1afed3020e908a4b4befb2f42b302946381b1ba1461f9106bc8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c1b55463dd33fb728b29727151df0c505add93d474e197221022cc0fe246769"
    sha256 cellar: :any_skip_relocation, ventura:        "7e913abb3fb064d195900e75f921f18f31aa553adaa501efb43888ffb77f2503"
    sha256 cellar: :any_skip_relocation, monterey:       "d8f0ae0cd2264cb0ac61d3a4afa5204968d711b952e57844b6a8fdfed9828b26"
    sha256 cellar: :any_skip_relocation, big_sur:        "b47125bda5b11d0f470f14a39057764c4ba7f45c82947f00f50479a8a9a70a10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cffa9c9979025649bd76c86ac3acde0beccc4c843b1f7c061a65b79c8704f2e3"
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
