class Jdupes < Formula
  desc "Duplicate file finder and an enhanced fork of 'fdupes'"
  homepage "https://codeberg.org/jbruchon/jdupes"
  url "https://codeberg.org/jbruchon/jdupes/archive/v1.31.1.tar.gz"
  sha256 "c80d4c1deb03cc891a7e938f886952cfc480b8a0bc48baf21b312d350b62d8e3"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ec259561869b02c328d62bfe624a1edfb0952222fcb3f9c02013c545cfc299cc"
    sha256 cellar: :any,                 arm64_sequoia: "97eadd05850f36865713dd989f6d8aa59103adba496c82337dc46a0e558073ba"
    sha256 cellar: :any,                 arm64_sonoma:  "7f5bfb653d6bf5c768ab9a71e562ae05e93d31a96ef855c28856f32f52ec7307"
    sha256 cellar: :any,                 sonoma:        "7d143118f5d529d58b96dbdf7cdaf969214fc51ee38b216824019fb73cc6f0c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96d668e71e1be10f6039352d2e613d9a55f9eb193df013cb56bfb58194d99490"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe8d8dbf09f5b79df229d4cc2d12cb2895a4eea6351d395c20d50129cbf40e31"
  end

  depends_on "libjodycode"

  def install
    # error: no member named 'st_mtim' in 'struct stat'
    inreplace "filestat.c" do |s|
      s.gsub! "st_mtim.tv_sec", "st_mtime"
      s.gsub! "st_atim.tv_sec", "st_atime"
    end

    system "make", "ENABLE_DEDUPE=1"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    touch "a"
    touch "b"
    (testpath/"c").write("unique file")
    dupes = shell_output("#{bin}/jdupes --zero-match .").strip.split("\n").sort
    assert_equal ["a", "b"], dupes
  end
end
