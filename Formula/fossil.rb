class Fossil < Formula
  desc "Distributed software configuration management"
  homepage "https://www.fossil-scm.org/home/"
  url "https://www.fossil-scm.org/home/uv/fossil-src-2.15.1.tar.gz"
  sha256 "80d27923c663b2a2c710f8ae8cd549862e04f8c04285706274c34ae3c8ca17d1"
  license "BSD-2-Clause"
  head "https://www.fossil-scm.org/", using: :fossil

  livecheck do
    url "https://www.fossil-scm.org/home/uv/download.js"
    regex(/"title":\s*?"Version (\d+(?:\.\d+)+)\s*?\(/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "9633bfbbc163a837543dd5b0c092ad5ed4ce62c37bbb8312bc968e43b85330dd"
    sha256 cellar: :any, big_sur:       "4786c0419fabc8af5fa66fc6c71153c4a90b8a9ead91cd0694e6e5239a157723"
    sha256 cellar: :any, catalina:      "7ddafb4ac71f80d9d96da8566d2d596899c2e8ad873551fb3f3f7d6c3c516585"
    sha256 cellar: :any, mojave:        "547cc3cdf20154d928c2be5b62f58005041c865073e551891a00f2ef4b2e020d"
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
