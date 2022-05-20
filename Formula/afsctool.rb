class Afsctool < Formula
  desc "Utility for manipulating APFS and ZFS compressed files"
  homepage "https://brkirch.wordpress.com/afsctool/"
  url "https://github.com/RJVB/afsctool/archive/refs/tags/1.7.2.tar.gz"
  sha256 "a0d01953e36a333c29369a126a81b905b70a5603533caeebc2f04bbd3aa1b0df"
  license all_of: ["GPL-3.0-only", "BSL-1.0"]
  head "https://github.com/RJVB/afsctool.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb8354b43a3be62e15b67539367e0fc34fa818f56b758f5d8875811d1eb683d2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0ad2029644ef5a0597750a5ef27f4da1f04441a49c2b9da63cf9d75e342ecff7"
    sha256 cellar: :any_skip_relocation, monterey:       "0a31f139ac8d56aa796446d6458f02a7a700d425e33e66824b407deeece709a9"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d4d08188fb559874d969a3e17ec43f3758f2f884db81a917cb839fa2da0d3b2"
    sha256 cellar: :any_skip_relocation, catalina:       "699723059b23cd7c9b91df35a38d0f0d308c61dc6ee3bcadd18b893ace2c9757"
  end

  depends_on "cmake" => :build
  depends_on "google-sparsehash" => :build
  depends_on "pkg-config" => :build
  depends_on :macos

  def install
    system "cmake", ".", *std_cmake_args
    system "cmake", "--build", "."
    bin.install "afsctool"
    bin.install "zfsctool"
  end

  test do
    path = testpath/"foo"
    path.write "some text here."
    system "#{bin}/afsctool", "-c", path
    system "#{bin}/afsctool", "-v", path

    system "#{bin}/zfsctool", "-c", path
    system "#{bin}/zfsctool", "-v", path
  end
end
