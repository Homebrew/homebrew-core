class JpegArchive < Formula
  desc "Utilities for archiving JPEGs for long term storage"
  homepage "https://github.com/danielgtaylor/jpeg-archive"
  url "https://github.com/danielgtaylor/jpeg-archive/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "3da16a5abbddd925dee0379aa51d9fe0cba33da0b5703be27c13a2dda3d7ed75"
  license "MIT"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "183d8acbdeec71e01c7848052ebb5e40dc3598dc2c9f86eb663d17e4e055220b"
    sha256 cellar: :any,                 arm64_sequoia: "0aef93bf72c6efee42cf3329fe9975550d977c51a389bdf5f7bee98e3c9b0cac"
    sha256 cellar: :any,                 arm64_sonoma:  "ce36b7e4deb24c1e3423cf85b15106bb3a3a2f7d38a112fdfaf6933e3b104cd1"
    sha256 cellar: :any,                 sonoma:        "18c2404353c92c320a6ce340d4e6b166fe6e9201472e91dae4a29826f59bb446"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "554ec3d5691c16246a42afffb1dfd791e943117810331feacfdf1a87208127df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0f07451e909abe52341b47d86aa6fdd8e0693726911322c4633b758c811249d"
  end

  depends_on "mozjpeg"

  def install
    # Work around failure from GCC 10+ using default of `-fno-common`
    # multiple definition of `progname'; /tmp/ccMJX1Ay.o:(.bss+0x0): first defined here
    # multiple definition of `VERSION'; /tmp/ccMJX1Ay.o:(.bss+0x8): first defined here
    ENV.append_to_cflags "-fcommon" if OS.linux?

    system "make", "install", "PREFIX=#{prefix}", "MOZJPEG_PREFIX=#{Formula["mozjpeg"].opt_prefix}", "LIBJPEG=-ljpeg"
  end

  test do
    system bin/"jpeg-recompress", test_fixtures("test.jpg"), "output.jpg"
  end
end
