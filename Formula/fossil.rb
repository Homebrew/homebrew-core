class Fossil < Formula
  desc "Distributed software configuration management"
  homepage "https://www.fossil-scm.org/"
  url "https://www.fossil-scm.org/index.html/uv/fossil-src-2.4.tar.gz"
  sha256 "d23498b6ae8894d18d7b73b8312c7514eda9ef91cf9f96c4c38429316919ad29"

  head "https://www.fossil-scm.org/", :using => :fossil

  bottle do
    cellar :any
    sha256 "bc988651d4ed64e8fa55fdafb9c1c9a8fb442bc14559e8ff3c2b42ac0e816fef" => :high_sierra
    sha256 "523704982ce10097cdf1a43d77a920c0776369a6e33757ec9ac94aa708e1b784" => :sierra
    sha256 "28b64773ea5f1cd4ebaa51ce65961e205a5b919d521d1fe473c620fa96ce757b" => :el_capitan
    sha256 "6d422e94e2ec8bf0ae41c387cf37377ca22d8523638b4613938403e912e7ea3e" => :yosemite
  end

  option "without-json", "Build without 'json' command support"
  option "without-tcl", "Build without the tcl-th1 command bridge"

  depends_on "openssl"
  depends_on :osxfuse => :optional

  def install
    args = [
      # fix a build issue, recommended by upstream on the mailing-list:
      # https://permalink.gmane.org/gmane.comp.version-control.fossil-scm.user/22444
      "--with-tcl-private-stubs=1",
    ]
    args << "--json" if build.with? "json"

    if MacOS::CLT.installed? && build.with?("tcl")
      args << "--with-tcl"
    else
      args << "--with-tcl-stubs"
    end

    if build.with? "osxfuse"
      ENV.prepend "CFLAGS", "-I/usr/local/include/osxfuse"
    else
      args << "--disable-fusefs"
    end

    system "./configure", *args
    system "make"
    bin.install "fossil"
  end

  test do
    system "#{bin}/fossil", "init", "test"
  end
end
