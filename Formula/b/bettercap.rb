class Bettercap < Formula
  desc "Swiss army knife for network attacks and monitoring"
  homepage "https://www.bettercap.org/"
  url "https://github.com/bettercap/bettercap/archive/refs/tags/v2.41.0.tar.gz"
  sha256 "6c2161acb85599a066bea2d28805f72cde68c13fefb8e67c5c72f3c31c3372c1"
  license "GPL-3.0-only"
  head "https://github.com/bettercap/bettercap.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "601b640cb814873f4bc494568d8e6bac3e0437d7e0f9b2dcae10050428c28285"
    sha256 cellar: :any,                 arm64_sonoma:  "6614522833be6dfbc677602367365feffb179216512c0d1ffd9e486003ee91ff"
    sha256 cellar: :any,                 arm64_ventura: "eafe12346381ada74b4731575c798968bb578c17b83f872ed83da548d0503780"
    sha256 cellar: :any,                 sonoma:        "e52b66aca3679d41baead4ba4dae3f239ad4f83c6387aa48bbfddf6f6b5e2959"
    sha256 cellar: :any,                 ventura:       "6d62416e253212a3d212fd0f904cf429782bcda5aa138da4ba0383f54cf51d75"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "289ba4d5fafb3902334b73fa4a6ceaf9f1879d5f1eb1c13a2d82b2ff813c3227"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "682d2dad8463513c60ff7eb7918b4f561d28d6dfdd8c7471ac136cdbb5935bf9"
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
        revision: "6e126c470e97542d724927ba975011244127dbb1"
  end

  def install
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
    assert_match expected, shell_output(bin/"bettercap 2>&1", 1)
  end
end
