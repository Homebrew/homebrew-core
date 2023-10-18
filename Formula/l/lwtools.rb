class Lwtools < Formula
  desc "Cross-development tools for Motorola 6809 and Hitachi 6309"
  homepage "http://www.lwtools.ca/"
  url "http://www.lwtools.ca/releases/lwtools/lwtools-4.21.tar.gz"
  sha256 "f668d943ef98be3427d683f5f3903e8e2900eb1cde4a611c988cfbb6c2b39e8f"
  license "GPL-3.0-only"

  livecheck do
    url "http://www.lwtools.ca/releases/lwtools/"
    regex(/href=.*?lwtools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a7b4e5836ac330914f881b78ee808d29d774a4e74f9ebde9e9496dffddb86652"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c4ce5ef71e65ca3c1d0e2252d7ef6a233a3d1a70b1e52ed146e5665f27f66e53"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9473fcd088c13b368abf13544b24c2ac747c040592ff072e40e09a737f349fc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c3b52a20e37bb1d72d7985c55951bfceb4b7289d1123bb2e29d3fc115fcd53b7"
    sha256 cellar: :any_skip_relocation, sonoma:         "2c042ecdcb303c0b72b2cfba05120b38d3e95966a9b6e16a9ec10f9c2b0aa49d"
    sha256 cellar: :any_skip_relocation, ventura:        "568d53de7606741d3d0f75580f69f3dc036f9e4a7ddadf6162267b231d3af14f"
    sha256 cellar: :any_skip_relocation, monterey:       "da8a43d1caa07c524d0fc0bbb1ee0adaf2bd3522b67fe82b3c96747d7a03e952"
    sha256 cellar: :any_skip_relocation, big_sur:        "03aaf64336da89a0986ba412935a2fafd59c5078562ea08263856e36d10f1f42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4aafa271709844e9c7685eeb2350b259f75d7565d00d7f7a347e3b6bb90a5367"
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    # lwasm
    (testpath/"foo.asm").write "  SECTION foo\n  stb $1234,x\n"
    system "#{bin}/lwasm", "--obj", "--output=foo.obj", "foo.asm"

    # lwlink
    system "#{bin}/lwlink", "--format=raw", "--output=foo.bin", "foo.obj"
    code = File.open("foo.bin", "rb") { |f| f.read.unpack("C*") }
    assert_equal [0xe7, 0x89, 0x12, 0x34], code

    # lwobjdump
    dump = `#{bin}/lwobjdump foo.obj`
    assert_equal 0, $CHILD_STATUS.exitstatus
    assert dump.start_with?("SECTION foo")

    # lwar
    system "#{bin}/lwar", "--create", "foo.lwa", "foo.obj"
    list = `#{bin}/lwar --list foo.lwa`
    assert_equal 0, $CHILD_STATUS.exitstatus
    assert list.start_with?("foo.obj")
  end
end
