class Fossil < Formula
  desc "Distributed software configuration management"
  homepage "https://www.fossil-scm.org/"
  url "https://www.fossil-scm.org/index.html/uv/fossil-src-2.12.1.tar.gz"
  sha256 "822326ffcfed3748edaf4cfd5ab45b23225dea840304f765d1d55d2e6c7d6603"
  license "BSD-2-Clause"
  head "https://www.fossil-scm.org/", using: :fossil

  livecheck do
    url "https://www.fossil-scm.org/index.html/uv/download.js"
    regex(/"title": *?"Version (\d+(?:\.\d+)+)/i)
  end

  bottle do
    cellar :any
    sha256 "79dddedf515aa4c145161b6511f99f8864656f19cd3935be77cf92bac60e1eb0" => :catalina
    sha256 "0366a7a4642f1805d593fd8c357df989cb811280afbef101bbc07fdcec4391d7" => :mojave
    sha256 "87006ce88d4bc52e452b06f2a10f8151930af1e0b6c14bace7eeb486505fd5b9" => :high_sierra
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
