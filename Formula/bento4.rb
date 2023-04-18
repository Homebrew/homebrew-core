class Bento4 < Formula
  desc "Full-featured MP4 format and MPEG DASH library and tools"
  homepage "https://www.bento4.com/"
  url "https://www.bok.net/Bento4/source/Bento4-SRC-1-6-0-639.zip"
  version "1.6.0-639"
  sha256 "3c6be48e38e142cf9b7d9ff2713e84db4e39e544a16c6b496a6c855f0b99cc56"
  license "GPL-2.0-or-later"
  revision 2

  livecheck do
    url "https://www.bok.net/Bento4/source/"
    regex(/href=.*?Bento4-SRC[._-]v?(\d+(?:[.-]\d+)+)\.zip/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f2db69d0fbf031a1dacf19666b4ce42c70ea6ee48a85288d415cfa7f14da015a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06c8735a1a883cd6608efca73cf337acf4041fae6c0322f580e440c3369027ac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0e46e50118a79968733d2304753c04820cddf882d84db7d5ddfc31031c447bf9"
    sha256 cellar: :any_skip_relocation, ventura:        "ac0e6060e12ad6d17701f4d68e34e37e18d20cc13a363f6f67dd2d7ee4c05857"
    sha256 cellar: :any_skip_relocation, monterey:       "88bb6a4f2d15bcbc5de0912f0cd60636ef9bbf9f981a30b543a9e04c24ec97fc"
    sha256 cellar: :any_skip_relocation, big_sur:        "6d46028ee2aaf030357c49f3dc85dbd2e9923b7e86ee3223dba3a15e2905e178"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a71cb51ac93babba09100d41b747987af0acc6264c147a0c15bf06663867ae78"
  end

  depends_on "cmake" => :build
  depends_on "python@3.11"

  conflicts_with "gpac", because: "both install `mp42ts` binaries"
  conflicts_with "mp4v2", because: "both install `mp4extract` and `mp4info` binaries"

  # Add support for cmake install.
  # TODO: Remove in the next release.
  patch do
    url "https://github.com/axiomatic-systems/Bento4/commit/ba95f55c495c4c34c75a95de843acfa00f6afe24.patch?full_index=1"
    sha256 "ba5984a122fd3971b40f74f1bb5942c34eeafb98641c32649bbdf5fe574256c5"
  end

  def install
    system "cmake", "-S", ".", "-B", "cmakebuild", *std_cmake_args
    system "cmake", "--build", "cmakebuild"
    system "cmake", "--install", "cmakebuild"

    rm Dir["Source/Python/wrappers/*.bat"]
    inreplace Dir["Source/Python/wrappers/*"],
              "BASEDIR=$(dirname $0)", "BASEDIR=#{libexec}/Python/wrappers"
    libexec.install "Source/Python"
    bin.install_symlink Dir[libexec/"Python/wrappers/*"]
  end

  test do
    system "#{bin}/mp4mux", "--track", test_fixtures("test.m4a"), "out.mp4"
    assert_predicate testpath/"out.mp4", :exist?, "Failed to create out.mp4!"
  end
end
