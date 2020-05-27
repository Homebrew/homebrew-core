class Fossil < Formula
  desc "Distributed software configuration management"
  homepage "https://www.fossil-scm.org/"
  url "https://www.fossil-scm.org/index.html/uv/fossil-src-2.11.tar.gz"
  sha256 "3d5a04bbe0075edd7f04c64ffc8f3af71d16565bf606b753f5d5752e48ff3631"
  head "https://www.fossil-scm.org/", :using => :fossil

  bottle do
    cellar :any
    sha256 "16afbe0d2eb0df60423b5274e368fd002bd9ab5af565c96535e0bae2c966f85c" => :catalina
    sha256 "901b5ea0ef15aa3cbe195dc33c925a6e6dbca03b2ff012ee1bfca800e58eca5f" => :mojave
    sha256 "6ae2eb58d9c1bfb35371a60a43a546fe619dd73350395ac4d11976bb5bebf486" => :high_sierra
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
