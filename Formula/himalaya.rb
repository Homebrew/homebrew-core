class Himalaya < Formula
  desc "CLI email client written in Rust"
  homepage "https://github.com/soywod/himalaya"
  url "https://github.com/soywod/himalaya/archive/v0.7.1.tar.gz"
  sha256 "79ad75e765a5298c5c597beb175cec1d2982eead2172bc78daa7a9f159c99861"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f352182c651945e219a845eeb9ae5e3feb89f364dd6e63fb86d92512f602333"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be4ffdc1d74df2130440233b316343033c49cda0718b80c4f2fed40ab7ecf9c5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8b5ec45e9cbb42f5be3fd37d0014c1c14fa1c4000c821d9d76313539793de905"
    sha256 cellar: :any_skip_relocation, ventura:        "a094234872441c3fc96d0d72306da6535ea10b1e5187b828243a4547541007b5"
    sha256 cellar: :any_skip_relocation, monterey:       "f3c399419f26b8aee5c322e57467955127480e67acd7861d42dac38890bc22a4"
    sha256 cellar: :any_skip_relocation, big_sur:        "101ff8f99348304ccf141a7e3893aa49e452afa3b04558e24c58dd20449faad3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8396adb7a697c0f3627ac7ff9c5ca352bd177c1199fba68072ac040fd20ec1d"
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
