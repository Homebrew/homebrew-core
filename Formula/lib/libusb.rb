class Libusb < Formula
  desc "Library for USB device access"
  homepage "https://libusb.info/"
  url "https://github.com/libusb/libusb/releases/download/v1.0.28/libusb-1.0.28.tar.bz2"
  sha256 "966bb0d231f94a474eaae2e67da5ec844d3527a1f386456394ff432580634b29"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fb9ed6ef1610e649e3b95f2eb2945f7329fc5695bcb2521c4dca924b61b3ff31"
    sha256 cellar: :any,                 arm64_sonoma:  "d6490cbec98bc45587edff71af6bc6c7807d120c8a938d5135120dfcde0ede95"
    sha256 cellar: :any,                 arm64_ventura: "81ee03b903ccaadf6624b56b94da8660b7530ff2ca1c91c0f3b9970c0aca9a43"
    sha256 cellar: :any,                 sonoma:        "161e0741fa3b4cd8efb5c750c1dd277214f57637320c1bd699f8a1f0a4ac1c2a"
    sha256 cellar: :any,                 ventura:       "d71077cf63c1b8903735656f3d7558d5e4a63588fe5ef5f9d612908e1dc848a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b240ee6dd7aca2c54bf65ed74391608418f2085ec6b7db0946550ea6aa98636"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5473c8faecc7be9a9ea04d712906ca4970fdf9abc1fc8713502a4eb4f8ca4d71"
  end

  head do
    url "https://github.com/libusb/libusb.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  on_linux do
    depends_on "systemd"
  end

  def install
    args = %W[--disable-dependency-tracking --prefix=#{prefix}]

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install"
    (pkgshare/"examples").install Dir["examples/*"] - Dir["examples/Makefile*"]
  end

  test do
    cp_r (pkgshare/"examples"), testpath
    cd "examples" do
      system ENV.cc, "listdevs.c", "-L#{lib}", "-I#{include}/libusb-1.0",
             "-lusb-1.0", "-o", "test"
      system "./test"
    end
  end
end
