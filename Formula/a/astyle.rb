class Astyle < Formula
  desc "Source code beautifier for C, C++, C#, and Java"
  homepage "https://astyle.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/astyle/astyle/astyle%203.6/astyle-3.6.9.tar.bz2"
  sha256 "b644597654df5b40087be4a46723c65040f7ce59f3369f1b8f690f9c10cababc"
  license "MIT"
  head "https://svn.code.sf.net/p/astyle/code/trunk/AStyle"

  livecheck do
    url :stable
    regex(%r{url=.*?/astyle[._-]v?(\d+(?:\.\d+)+)(?:[._-]linux)?\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1924b800e0762b97092a054f71a0b4a00000a46fbce445bbc1b08e80b834380b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b140cafb548eb0f68bf568638739a79394dbb00e86978e0ebe77c4929b30504d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2d380184cc9ed5666da4da07ac65deff0c31636299016f2590d81c301b747561"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a148a2a2d9fad398a2bf2f665d4248afd6fc8ed9c14b6aec384306e2b1e4661"
    sha256 cellar: :any_skip_relocation, ventura:       "127b30426d5873fc619831935328f3f52763e0bf6e8959fa91b8922b65f550d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8676bc30e1c62d74c38b79a8d675a310f609890c148b5f45444b66c128615fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e193b2a1b876b905a9bcc3c4487de747d26c2eaab0a87b4d2309d7d1f6a7540"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    man1.install "man/astyle.1"
  end

  test do
    (testpath/"test.c").write("int main(){return 0;}\n")
    system bin/"astyle", "--style=gnu", "--indent=spaces=4",
           "--lineend=linux", "#{testpath}/test.c"
    assert_equal File.read("test.c"), <<~C
      int main()
      {
          return 0;
      }
    C
  end
end
