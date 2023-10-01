class Astyle < Formula
  desc "Source code beautifier for C, C++, C#, and Java"
  homepage "https://astyle.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/astyle/astyle/astyle%203.4/astyle-3.4.8.tar.bz2"
  sha256 "0f32cb097dc121099cca420a0762c62297d5a5dbc8b994fc755cb47ff4c6c666"
  license "MIT"
  head "https://svn.code.sf.net/p/astyle/code/trunk/AStyle"

  livecheck do
    url :stable
    regex(%r{url=.*?/astyle[._-]v?(\d+(?:\.\d+)+)(?:[._-]linux)?\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d10de965c3f70e244f7ccfe07df9c21e6fdceebf6495598772e9520afc669bf3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a114dafc5cb75a0f475b791537b63acb249cc95b221a58654354143076f16b5f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bcb1a2cf4c4c9abde182ba3d376fb4ee2373b8ba3492e07100db93fcb653ec31"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "087297689e5b22bd8838f8253cccd5fc4c90871e4c78378f379554be5b42ff1f"
    sha256 cellar: :any_skip_relocation, sonoma:         "f6eed1124a08f862faa5fe61a6959c00b657b39618fd986374ad12fd8ee4cdd0"
    sha256 cellar: :any_skip_relocation, ventura:        "58cd2e468c999eabb1fbf3c4fc4b7e31a39123c9fa2e3572dbafc1616e11e2f0"
    sha256 cellar: :any_skip_relocation, monterey:       "06fc81105e2beefdaac1a22402330e27d59c48605ba4ac87378c637f82858e04"
    sha256 cellar: :any_skip_relocation, big_sur:        "e8f99641766c6f4e699c1395d4680647e211f96009fb86e0296d271e8dcc422a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a524c662d5ee2689ebecdba574a58a11443b6bc733a2a42f8adb3825825b5148"
  end

  def install
    cd "src" do
      system "make", "CXX=#{ENV.cxx}", "-f", "../build/gcc/Makefile"
      bin.install "bin/astyle"
    end
  end

  test do
    (testpath/"test.c").write("int main(){return 0;}\n")
    system "#{bin}/astyle", "--style=gnu", "--indent=spaces=4",
           "--lineend=linux", "#{testpath}/test.c"
    assert_equal File.read("test.c"), <<~EOS
      int main()
      {
          return 0;
      }
    EOS
  end
end
