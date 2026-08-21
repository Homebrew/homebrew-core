class Libusb < Formula
  desc "Library for USB device access"
  homepage "https://libusb.info/"
  url "https://github.com/libusb/libusb/releases/download/v1.0.30/libusb-1.0.30.tar.bz2"
  sha256 "fea36f34f9156400209595e300840767ab1a385ede1dc7ee893015aea9c6dbaf"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "184daaa6108f0a56eb72c58cc4124dbbb0b54a655632dffdf8334569d71e2a34"
    sha256 cellar: :any,                 arm64_sequoia: "a8d271bd5d9e7065987960caa52a9130d7fe6321ff1bad751499e465d0413e38"
    sha256 cellar: :any,                 arm64_sonoma:  "74fa9ed0291e2d3e7827a06ea836a57c96d8861a7079544d47be231f08eb4c02"
    sha256 cellar: :any,                 sonoma:        "1387aea9bbed3a1e57884b5b43166fc83cfdae415e5f3803a8259ff77a4ba613"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5789dcd1c84d316fa7f4ffec90277f0967f70a499cb239cefb37d919a3e5207"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ad452e6a96823fcef03781dd0980147b91690d0bb34c97f44e57130de8878f6"
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
