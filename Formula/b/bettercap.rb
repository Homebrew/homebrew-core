class Bettercap < Formula
  desc "Swiss army knife for network attacks and monitoring"
  homepage "https://www.bettercap.org/"
  url "https://github.com/bettercap/bettercap/archive/refs/tags/v2.33.0.tar.gz"
  sha256 "7e9f145edbe07f25b1d4c5132d9d6ed322ed728249f71acced1352459faf0e97"
  license "GPL-3.0-only"
  head "https://github.com/bettercap/bettercap.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c10f39c22e1b841405a0de96004ff1497f0c7e0f5dca3bcba8c108d40a963b81"
    sha256 cellar: :any,                 arm64_ventura:  "2a177b56a5def5cef15b93221ba367c52df7978b7d298f5a82a6ae70288c93a7"
    sha256 cellar: :any,                 arm64_monterey: "fd57aeec6a8468a41f536d22be35495e46cb5e5e3783d411f5f2462076873efb"
    sha256 cellar: :any,                 sonoma:         "1910fe533a6157e1aa96adcf4129c4db9971720ea25eed8d410101b571a4a43a"
    sha256 cellar: :any,                 ventura:        "a03c6bb0eb579549e4517c6e0a63027c8bd9e8b7a4173f42e55e9b1358a89284"
    sha256 cellar: :any,                 monterey:       "14e813d40077cb8fe4b80a0549302c711fa0db67a2715b189094c2af80f90165"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0e202f85a71512ed82aae96a525c8f12bede800958cf4b1d9b373b007125ce6"
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb"

  uses_from_macos "libpcap"

  on_linux do
    depends_on "libnetfilter-queue"
  end

  def install
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
