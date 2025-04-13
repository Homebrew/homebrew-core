class Proj < Formula
  desc "Cartographic Projections Library"
  homepage "https://proj.org/"
  url "https://github.com/OSGeo/PROJ/releases/download/9.6.0/proj-9.6.0.tar.gz"
  sha256 "d8cae521c311c39513193657e75767f7cfbf2f91bd202fcd4a200028d3b57e14"
  license "MIT"
  head "https://github.com/OSGeo/proj.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "0261f2c43f7824430e3c60e5babb33aeb669aced7984ec4780d12dd392a59e2c"
    sha256 arm64_sonoma:  "6d269647a386547eee11e8e093f94540c9f6beb262181ca897f8bf5b248a90da"
    sha256 arm64_ventura: "074e44f24a5afb86a56562189c6355f9b409fd6740a5c04a4dc556f3600af078"
    sha256 sonoma:        "e45bde228e370c95135aa3e8fa3a678ef3bf66e00de487819a784d917420fc40"
    sha256 ventura:       "22297d1171aa46943b6761b2be9d40b9916c6f15479b678b13808661ce3c716c"
    sha256 arm64_linux:   "5f93515c62af9522505323647c4aaa4b268ac2064c105db497c54ea999327a57"
    sha256 x86_64_linux:  "7109cbe388e8dbbc74ffb1511b9dae09dec6ad05e43a59c6ba032171ff3b270a"
  end

  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "libtiff"

  uses_from_macos "curl"
  uses_from_macos "sqlite"

  conflicts_with "blast", because: "both install a `libproj.a` library"

  skip_clean :la

  # The datum grid files are required to support datum shifting
  resource "proj-data" do
    url "https://download.osgeo.org/proj/proj-data-1.21.zip"
    sha256 "6bc292cd5dddefed1972549876587a8d45add1bf05824b6ad48637053719de74"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    system "cmake", "-S", ".", "-B", "static", *std_cmake_args, "-DBUILD_SHARED_LIBS=OFF"
    system "cmake", "--build", "static"
    lib.install Dir["static/lib/*.a"]
    resource("proj-data").stage do
      cp_r Dir["*"], pkgshare
    end
  end

  test do
    (testpath/"test").write <<~EOS
      45d15n 71d07w Boston, United States
      40d40n 73d58w New York, United States
      48d51n 2d20e Paris, France
      51d30n 7'w London, England
    EOS
    match = <<~EOS
      -4887590.49\t7317961.48 Boston, United States
      -5542524.55\t6982689.05 New York, United States
      171224.94\t5415352.81 Paris, France
      -8101.66\t5707500.23 London, England
    EOS

    output = shell_output("#{bin}/proj +proj=poly +ellps=clrk66 -r #{testpath}/test")
    assert_equal match, output
  end
end
