class Jdupes < Formula
  desc "Duplicate file finder and an enhanced fork of 'fdupes'"
  homepage "https://codeberg.org/jbruchon/jdupes"
  url "https://codeberg.org/jbruchon/jdupes/archive/v1.27.3.tar.gz"
  sha256 "1c75ed30dc95b3b5024019ab2ba3f78a14835c11d5b71249aa94374fde650c16"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "02e2f0c7780c83e355723d018999a5dd00d92421e87e6b1dc9c233f4f9ae95e5"
    sha256 cellar: :any,                 arm64_ventura:  "7d75d81a4d6e18f63f5b52f7935b2017eda93f22b7b0c392141cb9d475c058e9"
    sha256 cellar: :any,                 arm64_monterey: "1c5b59dd51ba019cfad6e3672ec4c4a4ab7f2bce7fc1ddaa0256657f122bd879"
    sha256 cellar: :any,                 sonoma:         "3ba11298b658aad10699c4abc91c6556b662472238da493baea8583af637848d"
    sha256 cellar: :any,                 ventura:        "a97e6a502b5904afa47d6728416c1a104d4fa5fb9ea36156b2161a5dff4438d0"
    sha256 cellar: :any,                 monterey:       "86bffc97357d11257b51ba5efc40b8fc740a546b1c79b2c80c726f8cd50a56d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "076b7519e52669599908fa54652c0e1bac8075d3bd4e2c3721e33a0b671958a6"
  end

  depends_on macos: :catalina # requires aligned_alloc

  resource "libjodycode" do
    url "https://codeberg.org/jbruchon/libjodycode.git",
        tag:      "v3.1",
        revision: "e44699edc8915f65635d2fa1c9dcfac38b1784c7"
  end

  def install
    ENV.append_to_cflags "-I#{include}"
    ENV.append "LDFLAGS", "-L#{lib}"

    resource("libjodycode").stage do
      system "make"
      system "make", "install", "PREFIX=#{prefix}"
    end

    system "make", "install", "PREFIX=#{prefix}", "ENABLE_DEDUPE=1"
  end

  test do
    touch "a"
    touch "b"
    (testpath/"c").write("unique file")
    dupes = shell_output("#{bin}/jdupes --zero-match .").strip.split("\n").sort
    assert_equal ["./a", "./b"], dupes
  end
end
