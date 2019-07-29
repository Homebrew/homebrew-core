class Bam < Formula
  desc "Build system that uses Lua to describe the build process"
  homepage "https://matricks.github.io/bam/"
  url "https://github.com/matricks/bam/archive/v0.5.1.tar.gz"
  sha256 "cc8596af3325ecb18ebd6ec2baee550e82cb7b2da19588f3f843b02e943a15a9"
  head "https://github.com/matricks/bam.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "195777b4263d8e5d84e91123ab1c47a362a5d92aa2c5c1cf7ac5c45b7728eb1d" => :mojave
    sha256 "59aebec505aba51189ccedb1872affd1c48ca84598caa591c2e0c955817e7cd7" => :high_sierra
    sha256 "f237da39dd743732f3cfa0a5029b3cce4b332fb08e4326183eece8fd50dcf789" => :sierra
    sha256 "4ded8f152aa05211053796e77b9b7a9e5671b9d5871c374a85ee74e6b9cb8e50" => :el_capitan
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
