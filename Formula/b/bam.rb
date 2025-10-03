class Bam < Formula
  desc "Build system that uses Lua to describe the build process"
  homepage "https://matricks.github.io/bam/"
  url "https://github.com/matricks/bam/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "cc8596af3325ecb18ebd6ec2baee550e82cb7b2da19588f3f843b02e943a15a9"
  license "Zlib"
  head "https://github.com/matricks/bam.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "4b8de9dd63dfda7b5b54d80b09458897660a18f8bc7e81ccf5fcf10e30890f69"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "adebb626ddcef7b484f65ffa378f7b8301106618b360871f442da91f2944a410"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3f96e777038d7de85e3cc3d52b30692f7980c1da78c82fa19447a1c0610c3e46"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b8e89910d5b1ebfbf030acf7e764ed714826bf7920f0dd5fe755861cee969784"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee7ac2a67e4d72ef0cea6c7c34afa9284bcba629991e8ec38ca185c2f470a472"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6c0a42f9cf83eabac04cd67c5441590f3fea48f7dd9aacd1a7fef524b4a40cf9"
    sha256 cellar: :any_skip_relocation, sonoma:         "a02a2877930db310c3de63b2a8fa34892ed25ca66030f90ef5db29c0169923ca"
    sha256 cellar: :any_skip_relocation, ventura:        "75d5f23cc6cfc164c893479517a3cfbdcae7f08ccade50ab8408a83cd5939e54"
    sha256 cellar: :any_skip_relocation, monterey:       "be83765718e57f62d746cd72d15451e4074bd34aa334f235dd0aeefbb760ba13"
    sha256 cellar: :any_skip_relocation, big_sur:        "0bd9f6ad25f64fc5282dd4facfea787bbca5855eb855c12eebb12cb60d82261b"
    sha256 cellar: :any_skip_relocation, catalina:       "de24826592ac3d7a97f2ea0372d6a002e67e39bc1f10dc5d2e54563f84953690"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "c8b66adf43d301d47e35cb5b45bf01bed4923f7eaf7496d08ded5d2bf70b2b64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1220e1a71792eacface17e8168d217ca657aeecf3b30a672a0815375536e2d1d"
  end

  def install
    system "./make_unix.sh"
    bin.install "bam"
  end

  test do
    (testpath/"hello.c").write <<~C
      #include <stdio.h>
      int main() {
        printf("hello\\n");
        return 0;
      }
    C

    (testpath/"bam.lua").write <<~LUA
      settings = NewSettings()
      objs = Compile(settings, Collect("*.c"))
      exe = Link(settings, "hello", objs)
    LUA

    system bin/"bam", "-v"
    assert_equal "hello", shell_output("./hello").chomp
  end
end
