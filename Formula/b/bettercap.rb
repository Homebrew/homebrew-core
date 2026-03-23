class Bettercap < Formula
  desc "Swiss army knife for network attacks and monitoring"
  homepage "https://www.bettercap.org/"
  url "https://github.com/bettercap/bettercap/archive/refs/tags/v2.41.5.tar.gz"
  sha256 "85513871e105a182eb92f80ba9563ac37cb8a48bcfa98d30e1197e74c42ff15a"
  license "GPL-3.0-only"
  head "https://github.com/bettercap/bettercap.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "15b798189de67d4dc426ab5c94cdccab4bf59182278b310a9aaadb7117eb6325"
    sha256 cellar: :any,                 arm64_sequoia: "e6203b04e0be9c73b1c6ea04fb1e7fd34bd128fc176b015b84342d0ef4ad1dab"
    sha256 cellar: :any,                 arm64_sonoma:  "668174c52388b7774f3fc48be0f033e62d0cc8b5ec9f6d36df143a43cef86f6b"
    sha256 cellar: :any,                 sonoma:        "fe3eec9287d1c782de232d5b4058a78618a8bf441bc07798cf3ca00dd2aceb95"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e103cd293cf7d899effe2c623ceee4e44dfc83f0742a2ab18d9bc242fb61a4a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d77279baf4543717c4c2799faacdb567499b07167b4958237208650b032ea51"
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
