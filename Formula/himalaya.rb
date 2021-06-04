class Himalaya < Formula
  desc "CLI email client written in Rust"
  homepage "https://github.com/soywod/himalaya"
  url "https://github.com/soywod/himalaya/archive/v0.4.0.tar.gz"
  sha256 "07359cc9827ecda8052a23428f642e06da5a899c40fe887acc5a880c76676131"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b9f1a4782b7eccff169258d151394248048c3d87383091464ee2f81c6f95b82e"
    sha256 cellar: :any_skip_relocation, big_sur:       "b312c3288de354c72d4fdeaffe0cad976b4e0b05fd8c07232b5b39bd2eeeff3a"
    sha256 cellar: :any_skip_relocation, catalina:      "32e04cd25c7c15f041ffbbb835d789b4d90aa1368d26478011d91d79e6303d7d"
    sha256 cellar: :any_skip_relocation, mojave:        "155a6e3097c420a9b48a6136778fc35b1deadec83047da7c1f5b4d92a81f32f8"
  end

  depends_on "rust" => :build

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

    assert_match "Could not login to IMAP server", shell_output("#{bin}/himalaya write 2>&1", 1)
  end
end
