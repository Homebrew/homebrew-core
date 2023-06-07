class Bam < Formula
  desc "Build system that uses Lua to describe the build process"
  homepage "https://matricks.github.io/bam/"
  url "https://github.com/matricks/bam/archive/v0.5.1.tar.gz"
  sha256 "cc8596af3325ecb18ebd6ec2baee550e82cb7b2da19588f3f843b02e943a15a9"
  license "Zlib"
  head "https://github.com/matricks/bam.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b8e89910d5b1ebfbf030acf7e764ed714826bf7920f0dd5fe755861cee969784"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee7ac2a67e4d72ef0cea6c7c34afa9284bcba629991e8ec38ca185c2f470a472"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6c0a42f9cf83eabac04cd67c5441590f3fea48f7dd9aacd1a7fef524b4a40cf9"
    sha256 cellar: :any_skip_relocation, ventura:        "75d5f23cc6cfc164c893479517a3cfbdcae7f08ccade50ab8408a83cd5939e54"
    sha256 cellar: :any_skip_relocation, monterey:       "be83765718e57f62d746cd72d15451e4074bd34aa334f235dd0aeefbb760ba13"
    sha256 cellar: :any_skip_relocation, big_sur:        "0bd9f6ad25f64fc5282dd4facfea787bbca5855eb855c12eebb12cb60d82261b"
    sha256 cellar: :any_skip_relocation, catalina:       "de24826592ac3d7a97f2ea0372d6a002e67e39bc1f10dc5d2e54563f84953690"
    sha256 cellar: :any_skip_relocation, mojave:         "195777b4263d8e5d84e91123ab1c47a362a5d92aa2c5c1cf7ac5c45b7728eb1d"
    sha256 cellar: :any_skip_relocation, high_sierra:    "59aebec505aba51189ccedb1872affd1c48ca84598caa591c2e0c955817e7cd7"
    sha256 cellar: :any_skip_relocation, sierra:         "f237da39dd743732f3cfa0a5029b3cce4b332fb08e4326183eece8fd50dcf789"
    sha256 cellar: :any_skip_relocation, el_capitan:     "4ded8f152aa05211053796e77b9b7a9e5671b9d5871c374a85ee74e6b9cb8e50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1220e1a71792eacface17e8168d217ca657aeecf3b30a672a0815375536e2d1d"
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
