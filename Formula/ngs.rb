class Ngs < Formula
  desc "Powerful programming language and shell designed specifically for Ops"
  homepage "https://ngs-lang.org/"
  url "https://github.com/ngs-lang/ngs/archive/v0.2.10.tar.gz"
  sha256 "361a36614a56bd7cb2cb0f4aa16addfefde478f9d2cbc1838eee3969262868c2"
  license "GPL-3.0"
  head "https://github.com/ngs-lang/ngs.git"

  bottle do
    cellar :any
    sha256 "45a732ac098d7e33c9152e13d31be724a1dd25735aefde86b683b528000dd118" => :big_sur
    sha256 "cf1ba2c19cbbb3491079aa81e61ed6c23ba6033b1196d8105c45ac290d893971" => :catalina
    sha256 "66c7eb7fcc89ed96624dd220b4cf8988897d4a65b4760349d00231d9c9aadecb" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "bdw-gc"
  depends_on "gnu-sed"
  depends_on "json-c"
  depends_on "pcre"
  depends_on "peg"

  uses_from_macos "libffi"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
    share.install prefix/"man"
  end

  test do
    assert_match "Hello World!", shell_output("#{bin}/ngs -e 'echo(\"Hello World!\")'")
  end
end
