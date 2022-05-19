class Agedu < Formula
  desc "Unix utility for tracking down wasted disk space"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/agedu/"
  url "https://www.chiark.greenend.org.uk/~sgtatham/agedu/agedu-20211129.8cd63c5.tar.gz"
  version "20211129"
  sha256 "ceaee592ef21b8cbb254aa7e9c5d22cefab24535e137618a4d0af591eba8339f"
  license "MIT"
  head "https://git.tartarus.org/simon/agedu.git", branch: "main"

  livecheck do
    url :homepage
    regex(/href=.*?agedu[._-]v?(\d+(?:\.\d+)*)(?:[._-][\da-z]+)?\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, monterey:     "f2905377040285017d03b3076635d691a7f0a590e9cffad230ed2e3c6b589852"
    sha256 cellar: :any_skip_relocation, big_sur:      "6b2aff0b1838cc529329fd0e178c05673b9e9879e3a8fc2910944d37ea027e0f"
    sha256 cellar: :any_skip_relocation, catalina:     "d5b1ceb8b45632543c913d12641cb820335b0e99fd823c9404222f0e087edef4"
    sha256 cellar: :any_skip_relocation, mojave:       "bb054128df68140a5cf8b7359a7d7c6357b13c08aa393b9481ff89124e614544"
    sha256 cellar: :any_skip_relocation, high_sierra:  "64a0584a579b71db75866548df7fef3eb7eb460023f3959aaf5e1c4d9e23bca8"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "5079b0c9090045244900e90d0845b3eaef544fa624ba2f5658467ef229201e31"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"agedu", "-s", "."
    assert_predicate testpath/"agedu.dat", :exist?
  end
end
