class Fossil < Formula
  desc "Distributed software configuration management"
  homepage "https://www.fossil-scm.org/home/"
  url "https://www.fossil-scm.org/home/tarball/fossil-src-2.16.tar.gz"
  sha256 "fab37e8093932b06b586e99a792bf9b20d00d530764b5bddb1d9a63c8cdafa14"
  license "BSD-2-Clause"
  head "https://www.fossil-scm.org/", using: :fossil

  livecheck do
    url "https://www.fossil-scm.org/home/uv/download.js"
    regex(/"title":\s*?"Version (\d+(?:\.\d+)+)\s*?\(/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "3a96c172e8a066c49f117b753a7d1655ab64258cc79f93c17139e1dc613e4e85"
    sha256 cellar: :any, big_sur:       "1ff4f25fe15fc701af2a61362cbb0696d70bef2ed1e1856cf5b8190c40ab5d1d"
    sha256 cellar: :any, catalina:      "038c7cab1f0d3455776a0e465b5cf3304bfdd8ec82c51f7b7908705fea5bc5ef"
    sha256 cellar: :any, mojave:        "086bc069937f2af94cc1c91da39aaba464928d7f663081c5a014c40856bba140"
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
