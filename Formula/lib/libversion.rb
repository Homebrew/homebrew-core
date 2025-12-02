class Libversion < Formula
  desc "Advanced version string comparison library"
  homepage "https://github.com/repology/libversion"
  url "https://github.com/repology/libversion/archive/refs/tags/3.0.4.tar.gz"
  sha256 "48c2a4a98b6f220dedd535979f1e9ab83f9bf869e06c0f5e7bb1be6d2e662fee"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "aa0840340937ed717b88fd8e3d56d4ab747ad9b1eacbcfdf9b29d26b5e7fab11"
    sha256 cellar: :any,                 arm64_sequoia: "3b984810fe806bdb1ce1d8f965f9aff9771dfb5367412e964e730ad874f216f4"
    sha256 cellar: :any,                 arm64_sonoma:  "0dc95a4d2de87071c6a8e34c3fdc63bafdd11884a64a2e1200bbbe7b91660635"
    sha256 cellar: :any,                 sonoma:        "324dc710d1d88152a1ec19383fb20ca152e17c6dbe73ed699fd7dfdd9c604dd4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70b5f6a09c1252dbc3b1d18705d38d54321577596ca79c10c45154ab71527784"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1df6a367f5b16560ed8d822188d0a5ccfd2fc3dc59fa437104a821029ba10a1e"
  end

  depends_on "cmake" => :build

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
