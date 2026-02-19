class Catimg < Formula
  desc "Insanely fast image printing in your terminal"
  homepage "https://github.com/posva/catimg"
  url "https://github.com/posva/catimg/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "1f4f54c237cd3b70c8a125044eb2578e8263c12b42d401a42c02c32f10f62548"
  license "MIT"
  head "https://github.com/posva/catimg.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2fefe411a3971353cb66a6bf61839e828df05bb729660c8c8b7ed5e53fe29416"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82957113d0c6d70108ccec7490751f4221c73ad482275c7b9a98b1e82a05aeb4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51bd2ed2bee5c7bb3189a7a5b636210db9e391f426e63ab3d9905087f66e2486"
    sha256 cellar: :any_skip_relocation, sonoma:        "450051c09fe144b11f92d570819ec7382759a6bdccdb51922082439ae6bd087d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ce1423dfbb07d5ab9c51d741a23feabd335bd10bbe1b43d750d4f04f1c23917"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f9207a4627e27aef315e6008051e1eac25d044083c04fbc66557264d4aa8063"
  end

  depends_on "cmake" => :build

  def install
    args = %W[-DMAN_OUTPUT_PATH=#{man1}]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"catimg", test_fixtures("test.png")
  end
end
