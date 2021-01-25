class Fossil < Formula
  desc "Distributed software configuration management"
  homepage "https://www.fossil-scm.org/"
  url "https://www.fossil-scm.org/index.html/uv/fossil-src-2.14.tar.gz"
  sha256 "b8d0c920196dd8ae29152fa7448e513a1fa7c588871b785e3fbfc07b42a05fb9"
  license "BSD-2-Clause"
  head "https://www.fossil-scm.org/", using: :fossil

  livecheck do
    url "https://www.fossil-scm.org/index.html/uv/download.js"
    regex(/"title": *?"Version (\d+(?:\.\d+)+)\s*?\(/i)
  end

  bottle do
    cellar :any
    sha256 "47b62a05daf6fc12735cc10ac3d661a058df73c918c0d425c8a06b5d33ceae40" => :big_sur
    sha256 "d0ac7394862b01c94118282bc7fe014ecc004818d0bdb5d7ad62ead3a4f8c789" => :arm64_big_sur
    sha256 "514265081557287157fad22327aed27e937229caa445a5ea363c7edee0ada162" => :catalina
    sha256 "a2c6c8c85d54a253ac499ea88402b397562db29e4f1d21d6103728921ff50335" => :mojave
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
