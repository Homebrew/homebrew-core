class Brainfuck < Formula
  desc "Interpreter for the brainfuck language"
  homepage "https://github.com/fabianishere/brainfuck"
  url "https://github.com/fabianishere/brainfuck/archive/2.7.3.tar.gz"
  sha256 "d99be61271b4c27e26a8154151574aa3750133a0bedd07124b92ccca1e03b5a7"
  license "Apache-2.0"
  head "https://github.com/fabianishere/brainfuck.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d4112d01c4118b43ef74885ec4a4b5ca2042a2fe3fcb6094e0d9b27d98749052"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b753b7dd2274926dbd763571f8b922fe270e25ee527ddd3a71cc4a1f7acb94de"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "802734b20ee8e8fc6eed4a1894c10b5e11810d006ff9346897179b085a4d244b"
    sha256 cellar: :any_skip_relocation, ventura:        "7d1a2e50deadc635f5ecde4166002b702eaba0c91869d24c5094d8eeb17c83cc"
    sha256 cellar: :any_skip_relocation, monterey:       "482ca8d67a9fd57c88e24d5763194e8e70f7e9d7c9dd8a7f3b5827097e2dfb6a"
    sha256 cellar: :any_skip_relocation, big_sur:        "3120d4eda67a0cf102317a5e0a4ecb36ca8ab99b75c2f0c8b76eabdffb31e252"
    sha256 cellar: :any_skip_relocation, catalina:       "3bc5affaa9e6ba7d7dc6c2f94ad1e63f36a6e19553a8f0183077322f4c9e9026"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3554b9a52daf8e246b2459186a891b82c2aa4ce70d900735288903cbc5150152"
  end

  depends_on "cmake" => :build

  uses_from_macos "libedit"

  def install
    system "cmake", ".", *std_cmake_args, "-DBUILD_SHARED_LIB=ON",
                         "-DBUILD_STATIC_LIB=ON", "-DINSTALL_EXAMPLES=ON"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/brainfuck -e '++++++++[>++++++++<-]>+.+.+.'")
    assert_equal "ABC", output.chomp
  end
end
