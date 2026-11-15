class Libversion < Formula
  desc "Advanced version string comparison library"
  homepage "https://github.com/repology/libversion"
  url "https://github.com/repology/libversion/archive/refs/tags/3.0.5.tar.gz"
  sha256 "b2da53a5adc8189332dbdf9bddd4f7ce897bcefac3755d8bcaf2a9a620682acd"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b7a785b641ffb48e8213c90beaccaf3d01998d0894860abfd1fadf436613a5c6"
    sha256 cellar: :any, arm64_tahoe:       "dbfb40139681cac0691d66561cf7d11b957389305112696eaf0376387fbf75f4"
    sha256 cellar: :any, arm64_sequoia:     "df7613f81e181bbb65b0f934809ca2161b2d8b76041d8a5fbbcb13df15916a6e"
    sha256 cellar: :any, arm64_linux:       "5b5413804cb77af9dbe725cdb9a70e190220b5355feb4dce90a3aeee30133375"
    sha256 cellar: :any, x86_64_linux:      "4ce2af21bfb4d6910f1e337d68a7c0fcdc61911f09a71886548e0e75fc4a15ae"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_equal "=", shell_output("#{bin}/version_compare 1.0 1.0.0").chomp
    assert_equal "<", shell_output("#{bin}/version_compare 1.1p1 1.1").chomp
    assert_equal ">", shell_output("#{bin}/version_compare -p 1.1p1 1.1").chomp
  end
end
