class Libcue < Formula
  desc "Cue sheet parser library for C"
  homepage "https://github.com/lipnitsk/libcue"
  url "https://github.com/lipnitsk/libcue/archive/v2.2.1.tar.gz"
  sha256 "f27bc3ebb2e892cd9d32a7bee6d84576a60f955f29f748b9b487b173712f1200"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f00d5a51c441a9698b375d1c2fca99a09e95dcc4a3931e2695aee332f46bd433"
    sha256 cellar: :any,                 arm64_big_sur:  "7619618f7bce8398ec7fe8ffd777012876cec3511a4bb595833770e9e631fed2"
    sha256 cellar: :any,                 monterey:       "834c3966f24d06ed8ae039608372601c20845ffc718893d81044e104103fafe0"
    sha256 cellar: :any,                 big_sur:        "cedf45a5d0ce2803b22527805777d7f185e4e9875f004dddca1ccd1000364d5d"
    sha256 cellar: :any,                 catalina:       "17252ea3af3c3a75478e8526ae7856dadfa641d7eb050553503bfe383573e740"
    sha256 cellar: :any,                 mojave:         "e3f6c16d235459f97b299627d359cb9fbe7526b8635e08521b1c36460b045162"
    sha256 cellar: :any,                 high_sierra:    "209e548399503830e0f786c6faef21836aa350d67db644b9ad291703ebe2e9c5"
    sha256 cellar: :any,                 sierra:         "14a6edb39d2887ad6beeb34dad944501d01f70480a529cb7e50d838833404f4f"
    sha256 cellar: :any,                 el_capitan:     "27f8ab5419958ea5817e5e44b68f24ea2a0c27d12a664556b12f6789866d0da5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "750eabefb348e1577ac23fd2d4d3ead2c21ef1f2596236ab59054067322d59c8"
  end

  depends_on "cmake" => :build

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    system "cmake", ".", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "make", "install"
    (pkgshare/"tests").install Dir["t/*"]
  end

  test do
    cp_r (pkgshare/"tests").children, testpath
    Dir["*.c"].each do |f|
      system ENV.cc, f, "-o", "test", "-L#{lib}", "-lcue", "-I#{include}"
      system "./test"
      rm "test"
    end
  end
end
