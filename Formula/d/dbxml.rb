class Dbxml < Formula
  desc "Embeddable XML database with XQuery support and other advanced features"
  homepage "https://www.oracle.com/database/technologies/related/berkeleydb.html"
  url "https://download.oracle.com/berkeley-db/dbxml-6.1.4.tar.gz"
  sha256 "a8fc8f5e0c3b6e42741fa4dfc3b878c982ff8f5e5f14843f6a7e20d22e64251a"
  license "AGPL-3.0-only"
  revision 4

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "539f926de917e73802a9590c4cfd28df6c3a54be13814265f6d80ec1943541cf"
    sha256 cellar: :any,                 arm64_sequoia: "b0de74f456722a21e4f77551d538b11d362b0fd48124c6eaa6b70b8d561f7480"
    sha256 cellar: :any,                 arm64_sonoma:  "efe2992cccae75a67b24df080b1ed9432e17754f929f445370baa20cdfde17c6"
    sha256 cellar: :any,                 arm64_ventura: "3b54187469d0a475dcd814126f9f15c82a9b66699edc45653e112ee24164ad2d"
    sha256 cellar: :any,                 sonoma:        "f5f58b63b160c729ff6350cec92474f1a9eed2ac3207413cd275b4ed6f19bbed"
    sha256 cellar: :any,                 ventura:       "67ce232d02670a98765d472293a358fb71f1d2ba3160786d218b4b3249275009"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30a75d75523b43d1a4b2eaeb6997cf8ebee9ed3d2e854c9387b1f474c65f79f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "936250b2d49f27ab6123d1eb1cc6405b22777dd95617d4aead5f958ac19e2a05"
  end

  depends_on "berkeley-db"
  depends_on "xerces-c"
  depends_on "xqilla"

  uses_from_macos "zlib"

  # No public bug tracker or mailing list to submit this to, unfortunately.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/dbxml/c%2B%2B11.patch"
    sha256 "98d518934072d86c15780f10ceee493ca34bba5bc788fd9db1981a78234b0dc4"
  end

  def install
    ENV.cxx11

    inreplace "dbxml/configure" do |s|
      s.gsub! %r{=`ls ("\$with_berkeleydb"/lib)/libdb-\*\.la \| sed -e 's/\.\*db-\\\(\.\*\\\)\.la/},
              "=`find \\1 -name #{shared_library("libdb-*")} -maxdepth 1 ! -type l " \
              "| sed -e 's/#{shared_library(".*db-\\(.*\\)")}/"
      s.gsub! "lib/libdb-*.la", "lib/#{shared_library("libdb-*")}"
      s.gsub! "libz.a", shared_library("libz")
    end

    args = %W[
      --with-xqilla=#{Formula["xqilla"].opt_prefix}
      --with-xerces=#{Formula["xerces-c"].opt_prefix}
      --with-berkeleydb=#{Formula["berkeley-db"].opt_prefix}
    ]
    args << "--with-zlib=#{Formula["zlib"].opt_prefix}" unless OS.mac?
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    cd "dbxml" do
      system "./configure", *std_configure_args, *args
      system "make", "install"
    end
  end

  test do
    (testpath/"simple.xml").write <<~XML
      <breakfast_menu>
        <food>
          <name>Belgian Waffles</name>
          <calories>650</calories>
        </food>
        <food>
          <name>Homestyle Breakfast</name>
          <calories>950</calories>
        </food>
      </breakfast_menu>
    XML

    (testpath/"dbxml.script").write <<~EOS
      createContainer ""
      putDocument simple "simple.xml" f
      cquery 'sum(//food/calories)'
      print
      quit
    EOS
    assert_equal "1600", shell_output("#{bin}/dbxml -s #{testpath}/dbxml.script").chomp
  end
end
