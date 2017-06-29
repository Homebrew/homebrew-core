class Io < Formula
  desc "Small prototype-based programming language"
  homepage "http://iolanguage.com/"
  revision 1

  head "https://github.com/stevedekorte/io.git"

  stable do
    url "https://github.com/stevedekorte/io/archive/2015.11.11.tar.gz"
    sha256 "00d7be0b69ad04891dd5f6c77604049229b08164d0c3f5877bfab130475403d3"

    # Fix build on Sierra. Already merged upstream.
    patch do
      url "https://github.com/stevedekorte/io/commit/db4d9c2.patch?full_index=1"
      sha256 "6ca94e7fd84da4f7e0b48f67fd862d2f5d10f159fa5c84b6af26c723acee77c3"
    end
  end

  bottle do
    sha256 "568f0e2970b3ebb0ee1407eddc76f6c9a7d7ce14284aa068266dfaa4ecb95f92" => :sierra
    sha256 "e78e1078cadd25d0991d8d8cdd4e2f8af114df23b253f2a0d864efccf6cbe233" => :el_capitan
    sha256 "39d88952df6b5ad7dd4622364e83c36011fda46faafc83145fb2d535586fd75b" => :yosemite
  end

  option "without-addons", "Build without addons"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  if build.with? "addons"
    depends_on "glib"
    depends_on "cairo"
    depends_on "gmp"
    depends_on "jpeg"
    depends_on "libevent"
    depends_on "libffi"
    depends_on "libogg"
    depends_on "libpng"
    depends_on "libsndfile"
    depends_on "libtiff"
    depends_on "libvorbis"
    depends_on "ossp-uuid"
    depends_on "pcre"
    depends_on "yajl"
    depends_on "xz"
    depends_on :python => :optional
  end

  def install
    ENV.deparallelize

    # FSF GCC needs this to build the ObjC bridge
    ENV.append_to_cflags "-fobjc-exceptions"

    if build.without? "addons"
      # Turn off all add-ons in main cmake file
      inreplace "CMakeLists.txt", "add_subdirectory(addons)",
                                  "#add_subdirectory(addons)"
    else
      inreplace "addons/CMakeLists.txt" do |s|
        if build.without? "python"
          s.gsub! "add_subdirectory(Python)", "#add_subdirectory(Python)"
        end

        # Turn off specific add-ons that are not currently working

        # Looks for deprecated Freetype header
        s.gsub!(/(add_subdirectory\(Font\))/, '#\1')
        # Builds against older version of memcached library
        s.gsub!(/(add_subdirectory\(Memcached\))/, '#\1')
      end
    end

    mkdir "buildroot" do
      system "cmake", "..", *std_cmake_args
      system "make"
      output = `./_build/binaries/io ../libs/iovm/tests/correctness/run.io`
      if $CHILD_STATUS.exitstatus.nonzero?
        opoo "Test suite not 100% successful:\n#{output}"
      else
        ohai "Test suite ran successfully:\n#{output}"
      end
      system "make", "install"
    end
  end

  test do
    (testpath/"test.io").write <<-EOS.undent
      "it works!" println
    EOS

    assert_equal "it works!\n", shell_output("#{bin}/io test.io")
  end
end
