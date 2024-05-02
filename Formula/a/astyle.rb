class Astyle < Formula
  desc "Source code beautifier for C, C++, C#, and Java"
  homepage "https://astyle.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/astyle/astyle/astyle%203.4/astyle-3.4.14.tar.bz2"
  sha256 "606a83f39146733185f6763059d292433c40f393eb6f52042e163f8df4e16a3e"
  license "MIT"
  head "https://svn.code.sf.net/p/astyle/code/trunk/AStyle"

  livecheck do
    url :stable
    regex(%r{url=.*?/astyle[._-]v?(\d+(?:\.\d+)+)(?:[._-]linux)?\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e1f6d79cb1cdc6af7c6df8f7aadbe9c6793b61c5b4172817a6c6f58e28bf42ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d9f46ba46d47b9f3534554cda6d07725cab54b65143d632c3608e06649648e54"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4850a7e8d0f9894087893153528bcc80258f8cceb4131cb3156030ab9c94d0c"
    sha256 cellar: :any_skip_relocation, sonoma:         "c8802d27b7a53a488912ea6697bec11931e6b9606b1a508275da4ffbffd5272a"
    sha256 cellar: :any_skip_relocation, ventura:        "907dfefce040a024533e60f5a3ccb87a8b3d3f648da0692e40ed23ee501ad532"
    sha256 cellar: :any_skip_relocation, monterey:       "b440b0ae21e0cf7f8a61d8b25594e988f5804be7df60db381f498570959735a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ba73cbd773ae8bfd0724850a90606efe8f190b09fb75afabacc5abc01388408"
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
