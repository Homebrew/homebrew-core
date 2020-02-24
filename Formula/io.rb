class Io < Formula
  desc "Small prototype-based programming language"
  homepage "http://iolanguage.com/"
  url "https://github.com/IoLanguage/io/archive/2017.09.06.tar.gz"
  sha256 "9ac5cd94bbca65c989cd254be58a3a716f4e4f16480f0dc81070457aa353c217"
  revision 1
  head "https://github.com/IoLanguage/io.git"

  bottle do
    sha256 "c4c862d20a8e4ddb1e6e588414a9e23ae2a17baa490e3beb621614aca7a8ca87" => :catalina
    sha256 "48c37d6f30d8b01d391e7f4ef777b5087425d89a9df0077414769a59333db420" => :mojave
    sha256 "a061482b97c1ada8eea9d658f13fe0cfbfa223d97762b51611c4cab2de4c0273" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  uses_from_macos "libxml2"

  def install
    ENV.deparallelize

    # FSF GCC needs this to build the ObjC bridge
    ENV.append_to_cflags "-fobjc-exceptions"

    unless build.head?
      # Turn off all add-ons in main cmake file
      inreplace "CMakeLists.txt", "add_subdirectory(addons)",
                                  "#add_subdirectory(addons)"
    end

    mkdir "buildroot" do
      system "cmake", "..", "-DCMAKE_DISABLE_FIND_PACKAGE_ODE=ON",
                            "-DCMAKE_DISABLE_FIND_PACKAGE_Theora=ON",
                            *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.io").write <<~EOS
      "it works!" println
    EOS

    assert_equal "it works!\n", shell_output("#{bin}/io test.io")
  end
end
