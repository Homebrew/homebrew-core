class Bam < Formula
  desc "Build system that uses Lua to describe the build process"
  homepage "https://matricks.github.io/bam/"
  url "https://github.com/matricks/bam/archive/v0.5.1.tar.gz"
  sha256 "cc8596af3325ecb18ebd6ec2baee550e82cb7b2da19588f3f843b02e943a15a9"
  head "https://github.com/matricks/bam.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "71b25578865fa044fdb5d233eee5ca327d602c9ef291af2e98780aef6b469ca2" => :high_sierra
    sha256 "1ed38b80dc9aaad3e9a4655cd28ad95d8f2d7392f5b5bbdb1dbd210665aa4281" => :sierra
    sha256 "bdf84408b791d7e5dca2e0f96cec0aea62f549611a8f6e1c0ea4b8dd8b03d7c0" => :el_capitan
    sha256 "1d76b73f0b46d0bb9f0ba998128abd1271f79ca5d2016703ac783a55369892e2" => :yosemite
    sha256 "505d0773336c1820057945fc016af04a1ea8b159d042725f435dd314e0f07f67" => :mavericks
  end

  def install
    system "./make_unix.sh"
    bin.install "bam"
  end

  test do
    (testpath/"hello.c").write <<~EOS
      #include <stdio.h>
      int main() {
        printf("hello\\n");
        return 0;
      }
    EOS

    (testpath/"bam.lua").write <<~EOS
      settings = NewSettings()
      objs = Compile(settings, Collect("*.c"))
      exe = Link(settings, "hello", objs)
    EOS

    system bin/"bam", "-v"
    assert_equal "hello", shell_output("./hello").chomp
  end
end
