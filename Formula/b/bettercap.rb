class Bettercap < Formula
  desc "Swiss army knife for network attacks and monitoring"
  homepage "https://www.bettercap.org/"
  url "https://github.com/bettercap/bettercap/archive/refs/tags/v2.41.7.tar.gz"
  sha256 "797274ac3a4e35e40e640958c267a60f559213d9ae1322ab721d8f4ec71cbaeb"
  license "GPL-3.0-only"
  head "https://github.com/bettercap/bettercap.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "faf6aeb244e61de6dd3a3f0d42273ff1d6081e502a70141a31d0052e6cc5c8b0"
    sha256 cellar: :any,                 arm64_sequoia: "6492c09568d8bb7e396acef38be1bc5dd79bc70cbc6e94252af742f6e98b4f0a"
    sha256 cellar: :any,                 arm64_sonoma:  "1b63c6988896778611a76c07abba8772351946fd5537cd22d6390eac8251f702"
    sha256 cellar: :any,                 sonoma:        "24af0789079b4ae2835f467f50c3af839c8677e74613eb032a99f1a361325484"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "810b00e8d5ed76b2feed206f36822047e822e4847d63bca5d40eece927f01b21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e71a3a6cd746e9f1acefe81649ccf5fa0d71c7f086dbee1b84c2895a93186664"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "libusb"

  uses_from_macos "libpcap"

  on_linux do
    depends_on "libnetfilter-queue"
  end

  resource "ui" do
    url "https://github.com/bettercap/ui.git",
        revision: "ca482e9820552bc71acba6047504efbd0a05043f"
  end

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?
    (buildpath/"modules/ui/ui").install resource("ui")
    system "make", "build"
    bin.install "bettercap"
  end

  def caveats
    <<~EOS
      bettercap requires root privileges so you will need to run `sudo bettercap`.
      You should be certain that you trust any software you grant root privileges.
    EOS
  end

  test do
    expected = if OS.mac?
      "Operation not permitted"
    else
      "Permission Denied"
    end
    assert_match expected, shell_output("#{bin}/bettercap 2>&1", 1)
  end
end
