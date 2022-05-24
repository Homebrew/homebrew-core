class Fossil < Formula
  desc "Distributed software configuration management"
  homepage "https://www.fossil-scm.org/home/"
  url "https://fossil-scm.org/home/tarball/version-2.18/fossil-src-2.18.tar.gz"
  sha256 "300c1d5cdd6224ec6e8c88ab3f38d50f80e4071b503731b75bd61274cf310733"
  license "BSD-2-Clause"
  head "https://www.fossil-scm.org/", using: :fossil

  livecheck do
    url "https://www.fossil-scm.org/home/uv/download.js"
    regex(/"title":\s*?"Version (\d+(?:\.\d+)+)\s*?\(/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "84d5f38c5c255511f45d83f92021c5cb35d97487615267f4cb5e4adf3273850c"
    sha256 cellar: :any,                 arm64_big_sur:  "90f5144c381820554b28de7f37d6a74b07dccf0e9244098a4f45d9b5110343b3"
    sha256 cellar: :any,                 monterey:       "fe99b0cf0e77a8b7801bcf40bb6fdc17720c10d42a96356a05c7fe3db35bf2c9"
    sha256 cellar: :any,                 big_sur:        "4d809209bcdb6c15a896e27718c4bf0ce0383bb43dd36d46f9e3fc186c9cdd86"
    sha256 cellar: :any,                 catalina:       "c6275833e4dff742fdf394cc769078aab4dd2a5df9cad261fc655470e55229c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f021d8c90ad5e56e6dec0e7adf455c69ae481592b946815b41fb193f7b64d014"
  end

  depends_on "openssl@1.1"
  uses_from_macos "zlib"

  def install
    args = [
      # fix a build issue, recommended by upstream on the mailing-list:
      # https://permalink.gmane.org/gmane.comp.version-control.fossil-scm.user/22444
      "--with-tcl-private-stubs=1",
      "--json",
      "--disable-fusefs",
    ]

    args << if MacOS.sdk_path_if_needed
      "--with-tcl=#{MacOS.sdk_path}/System/Library/Frameworks/Tcl.framework"
    else
      "--with-tcl-stubs"
    end

    system "./configure", *args
    system "make"
    bin.install "fossil"
  end

  test do
    system "#{bin}/fossil", "init", "test"
  end
end
