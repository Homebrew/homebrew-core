class Aspcud < Formula
  desc "Package dependency solver"
  homepage "https://potassco.org/aspcud/"
  url "https://github.com/potassco/aspcud/archive/refs/tags/v1.9.6.tar.gz"
  sha256 "4dddfd4a74e4324887a1ddd7f8ff36231774fc1aa78b383256546e83acdf516c"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "38a5c5010a8e9f38e95233d7b20dcdb75b76c33e1cb3f80410dc01b277ddc17e"
    sha256 arm64_sequoia:  "429008eb29edff4d08e840bd0eb373ea061c357d01ebab4e416f9d4681b95b0a"
    sha256 arm64_sonoma:   "f9754209fbab844fa1dc333dd669715fb973838a82f87c44580f9198a56b94ea"
    sha256 arm64_ventura:  "559e837a693b869dd122da250d57f222501b1f352bf57258eb4305530f8d30a0"
    sha256 arm64_monterey: "99122c4ae30f0760d00103191fb33b4fd793ac65e45f662a64d1386e0775d85f"
    sha256 arm64_big_sur:  "59e462b9a05482e92ccee1a483642515afe98cf8180d22ec414b16282513cb6d"
    sha256 sonoma:         "edc44ff90fbf5353a53ddc431d73054561379ebb1d512fbb3779a1ba6a92ac2b"
    sha256 ventura:        "89f0c16b2804c20cda2b800f9504753b2151ab6b2418d77e55eee1b35a3cb652"
    sha256 monterey:       "8920dad4979d2ae3542553312c906d917ad1cbfe9f9059f4ee6bd726408489df"
    sha256 big_sur:        "8b458c28102da4cbc936a8ee349f4ce95764c801a70e0031dd2007b94e93d1ef"
    sha256 catalina:       "ae23d915a2acf5de9083c065c41df839558ac272725ef76e8ac269498b5cabe0"
    sha256 arm64_linux:    "eda6f25c685bc5b196faf5a997403db0ed730f2cf4e7f680ca316861ac979bce"
    sha256 x86_64_linux:   "38882525e9e80e2f8436800e20415bd7f584130f264fdacf484c4c11a2ee0076"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "re2c" => :build
  depends_on "clingo"

  def install
    args = %W[
      -DASPCUD_GRINGO_PATH=#{Formula["clingo"].opt_bin}/gringo
      -DASPCUD_CLASP_PATH=#{Formula["clingo"].opt_bin}/clasp
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"in.cudf").write <<~EOS
      package: foo
      version: 1

      request: foo >= 1
    EOS
    system bin/"aspcud", "in.cudf", "out.cudf"
  end
end
