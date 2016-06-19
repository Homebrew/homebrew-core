class Bam < Formula
  desc "Build system that uses Lua to describe the build process"
  homepage "https://matricks.github.io/bam/"
  url "https://github.com/matricks/bam/archive/v0.5.0.tar.gz"
  sha256 "16c0bccb6c5dee62f4381acaa004dd4f7bc9a32c10d0f2a40d83ea7e2ae25998"
  head "https://github.com/matricks/bam.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "40501301dcb3d0af9ca402535d91b79729a684978299d52f3595274f0385a9a6" => :el_capitan
    sha256 "832033a89e90b4152690ac9738af8db839f322e79b7169bc8bdf1a866707cf22" => :yosemite
    sha256 "ba4ee90c3fc9001761bf2c09906c5c3df66c6175d7b763fa3527c3c512c2f2d5" => :mavericks
    sha256 "73362b46dfe24dc3d6c4bb59bdb9d0403ec717054428f78bc9dd32a93343a187" => :mountain_lion
  end

  # Fixes "[string "src/tools.lua"]:165: no driver set"; patch is from upstream
  patch do
    url "https://github.com/matricks/bam/commit/27b28f09.patch"
    sha256 "12488633b7feaf486c92427d64a0ebad41ddf5b3195a8d4708e51a8db8c7b7c0"
  end

  def install
    system "./make_unix.sh"
    bin.install "bam"
  end

  test do
    (testpath/"hello.c").write <<-EOS.undent
      #include <stdio.h>
      int main() {
        printf("hello\\n");
        return 0;
      }
    EOS

    (testpath/"bam.lua").write <<-EOS.undent
      settings = NewSettings()
      objs = Compile(settings, Collect("*.c"))
      exe = Link(settings, "hello", objs)
    EOS

    system bin/"bam", "-v"
    assert_equal "hello", shell_output("./hello").chomp
  end
end
