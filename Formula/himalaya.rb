class Himalaya < Formula
  desc "CLI email client written in Rust"
  homepage "https://github.com/soywod/himalaya"
  url "https://github.com/soywod/himalaya/archive/v0.7.1.tar.gz"
  sha256 "79ad75e765a5298c5c597beb175cec1d2982eead2172bc78daa7a9f159c99861"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c183673661e25ba4277a2bb41870e0af62b526d69b88b7d0f8ae1f1ab64daadf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79a0704bb6ea9ded4c58cbeb4511f5c0f61ee422b69ca60c65cb9f9045aa6d51"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "162939545f884442ba8fd73fb22378dab7fd3a65f9716e4a6cc9bc065eed4948"
    sha256 cellar: :any_skip_relocation, ventura:        "803de34f44ba6acbe9d18b5be80c34ce8686caa681427a8e81cc96b2f644b7e7"
    sha256 cellar: :any_skip_relocation, monterey:       "03356483a4613a45e9f43a1ab17fb1ab9dcb904b124187aae1d67f007a66c42b"
    sha256 cellar: :any_skip_relocation, big_sur:        "d710c797f05cf94f8ae6e116495856d77fa422dd444c316890e6ea2bb9c33eb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02c4100bf487465e0628199873202c01af60c7d3013282af8b78673818995c9e"
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
