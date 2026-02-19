class Dbxml < Formula
  desc "Embeddable XML database with XQuery support and other advanced features"
  homepage "https://www.oracle.com/database/technologies/related/berkeleydb.html"
  url "https://download.oracle.com/berkeley-db/dbxml-6.1.4.tar.gz"
  sha256 "a8fc8f5e0c3b6e42741fa4dfc3b878c982ff8f5e5f14843f6a7e20d22e64251a"
  license "AGPL-3.0-only"
  revision 4

  livecheck do
    skip "No longer developed or maintained"
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "3828eca647ae656062c684b2a22643d28cd2f0f1664ec44c960a5f7b20a7d5e6"
    sha256 cellar: :any,                 arm64_sequoia: "2166cda564eb4f6e94f668bb382754318e67ef46b591e4a6a3739a234876656d"
    sha256 cellar: :any,                 arm64_sonoma:  "ba173a558212fb40fa962959759c2217185e2827a30fa47ea516e82e449c2f22"
    sha256 cellar: :any,                 sonoma:        "e40be797484590b2d264134fff52a2f77dd3e8e7f1104bbc312d9618828b9e0f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a19a0a31bfa89f8b1ae945f05cd44281267114d25d49cc6f0b3f06f6c3f43bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afed5853113aeb049c66efecd663697396c9cca6466c67c5b34b7f37981415c6"
  end

  depends_on "berkeley-db"
  depends_on "xerces-c"
  depends_on "xqilla"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # No public bug tracker or mailing list to submit this to, unfortunately.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/2c3abc44ccac26dc8ecf09a8fb6cf33f47b5cfc9/Patches/dbxml/cxx11.patch"
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
    args << "--with-zlib=#{Formula["zlib-ng-compat"].opt_prefix}" unless OS.mac?
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm64?

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
