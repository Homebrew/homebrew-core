class Astyle < Formula
  desc "Source code beautifier for C, C++, C#, and Java"
  homepage "https://astyle.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/astyle/astyle/astyle%203.6/astyle-3.6.13.tar.bz2"
  sha256 "048b74b14c6e01f7fae8e63b767da33303ab39d9022afe33055ce4b9e56f162d"
  license "MIT"
  head "https://svn.code.sf.net/p/astyle/code/trunk/AStyle"

  livecheck do
    url :stable
    regex(%r{url=.*?/astyle[._-]v?(\d+(?:\.\d+)+)(?:[._-]linux)?\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c1c6fc89470242b5c172c5bdcca02db6296caaf0f96a9a338dda98a0a9d603d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb581f7a3a7f042c2eacc69eb37d7919ff42333a2104bc096668374b4a08f9ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75567d1c83c98f50e0b5d977eb9adc66ec3f73ab306b64b7024456bd90d7de5f"
    sha256 cellar: :any_skip_relocation, sonoma:        "961ad7ab777fd4fa58e89e29e6436c535ea9df87e567c64321ddcb0f0d86992f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d26e61ddec42b911465f31ffc7ea6a2ed135bc083d6c581c24f833b799f5dec5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d04d6901ab8db87f311aaaa01d0bd1b9c94dba81f7b6478efed4ddad868269b6"
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
