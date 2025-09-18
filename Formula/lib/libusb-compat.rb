class LibusbCompat < Formula
  desc "Library for USB device access"
  homepage "https://libusb.info/"
  url "https://downloads.sourceforge.net/project/libusb/libusb-compat-0.1/libusb-compat-0.1.8/libusb-compat-0.1.8.tar.bz2"
  sha256 "b692dcf674c070c8c0bee3c8230ce4ee5903f926d77dc8b968a4dd1b70f9b05c"
  license all_of: [
    "LGPL-2.1-or-later",
    any_of: ["LGPL-2.1-or-later", "BSD-3-Clause"], # libusb/usb.h
  ]

  livecheck do
    url :stable
    regex(%r{url=.*?/libusb-compat[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "63dfe2cf30c69c8f654177fbd754d013e0b5d86636cf731f5e22fbf3071d228e"
    sha256 cellar: :any,                 arm64_sequoia:  "db9c3980772b1debe48a65b951a7b6ac27ccfacd26afc6b96b49fa1a60c34339"
    sha256 cellar: :any,                 arm64_sonoma:   "64e879dd5f99d9e95ef207caf668bd1363d79f660abc1ec60c44eeb7082cb216"
    sha256 cellar: :any,                 arm64_ventura:  "a2fcb4b8c54d64c71ca73d7b70573617b9df000d7cd8040925c45627a601f84f"
    sha256 cellar: :any,                 arm64_monterey: "b963fa8ff806b92ea8d4a278ae9fd41e8e86c9dbad743c8848f0962363e48104"
    sha256 cellar: :any,                 sonoma:         "4ee27e4e0b9a716fd2b15db94b1595901276078780d377432e2fde4e9d78c324"
    sha256 cellar: :any,                 ventura:        "9d752b7aea1ecaa42c8c7127d986a149ab971bc020689bf6007b27431c2ddc9d"
    sha256 cellar: :any,                 monterey:       "82d8bd5747595f694da174d66f1b61f407d904f7741f3dfc8d8d342c1239c5a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "878121af3e546d38c3574dd0d43f284044fdfab4c6930cd14e615bce37801d4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0201a3ccb74c1a239274bf0d0ed68541e738d09f4ae46dd93501334bce39c24c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "libusb"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"libusb-config", "--libs"
  end
end
