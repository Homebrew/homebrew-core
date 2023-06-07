class Aspcud < Formula
  desc "Package dependency solver"
  homepage "https://potassco.org/aspcud/"
  url "https://github.com/potassco/aspcud/archive/v1.9.6.tar.gz"
  sha256 "4dddfd4a74e4324887a1ddd7f8ff36231774fc1aa78b383256546e83acdf516c"
  license "MIT"

  bottle do
    sha256 arm64_ventura:  "559e837a693b869dd122da250d57f222501b1f352bf57258eb4305530f8d30a0"
    sha256 arm64_monterey: "99122c4ae30f0760d00103191fb33b4fd793ac65e45f662a64d1386e0775d85f"
    sha256 arm64_big_sur:  "59e462b9a05482e92ccee1a483642515afe98cf8180d22ec414b16282513cb6d"
    sha256 ventura:        "89f0c16b2804c20cda2b800f9504753b2151ab6b2418d77e55eee1b35a3cb652"
    sha256 monterey:       "8920dad4979d2ae3542553312c906d917ad1cbfe9f9059f4ee6bd726408489df"
    sha256 big_sur:        "8b458c28102da4cbc936a8ee349f4ce95764c801a70e0031dd2007b94e93d1ef"
    sha256 catalina:       "ae23d915a2acf5de9083c065c41df839558ac272725ef76e8ac269498b5cabe0"
    sha256 x86_64_linux:   "38882525e9e80e2f8436800e20415bd7f584130f264fdacf484c4c11a2ee0076"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "re2c" => :build
  depends_on "clingo"

  def install
    args = std_cmake_args
    args << "-DASPCUD_GRINGO_PATH=#{Formula["clingo"].opt_bin}/gringo"
    args << "-DASPCUD_CLASP_PATH=#{Formula["clingo"].opt_bin}/clasp"

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"in.cudf").write <<~EOS
      package: foo
      version: 1

      request: foo >= 1
    EOS
    system "#{bin}/aspcud", "in.cudf", "out.cudf"
  end
end
