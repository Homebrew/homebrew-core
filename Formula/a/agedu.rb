class Agedu < Formula
  desc "Unix utility for tracking down wasted disk space"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/agedu/"
  url "https://www.chiark.greenend.org.uk/~sgtatham/agedu/agedu-20260410.3622eda.tar.gz"
  version "20260410"
  sha256 "37be3c0de116b4fa44d390cca929248fd2e12586ef22aca9474a009c568e561c"
  license "MIT"
  head "https://git.tartarus.org/simon/agedu.git", branch: "main"

  livecheck do
    url :homepage
    regex(/href=.*?agedu[._-]v?(\d+(?:\.\d+)*)(?:[._-][\da-z]+)?\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1776ad42208d2b479ecc2cf2bdd0d4c9f95dc26e424a13f2fce7deae0267ee6d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd3c26c8565f3506b66e395109a6e45e30fbfa07517059a03478197e7a8f53b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7510c68d8ec7fb8e5653b2f9063b11cfd2ab1a487f54cd9a515b28835880e6c"
    sha256 cellar: :any_skip_relocation, sonoma:        "2285ea17daf0fd9c3fab4a2ff2b7585371da3c5eaf78fca6d200a89278d1d16c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cef4816008da1f0a3190e0e90135f35bf42245400bf06d6a9238b1df1ad62d68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5dea82a31c4ec6d830ba80b94cbd2c5b23c10187e10bd345e6806b2c88b82b56"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"agedu", "-s", "."
    assert_path_exists testpath/"agedu.dat"
  end
end
