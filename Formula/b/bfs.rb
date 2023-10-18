class Bfs < Formula
  desc "Breadth-first version of find"
  homepage "https://tavianator.com/projects/bfs.html"
  url "https://github.com/tavianator/bfs/archive/3.0.4.tar.gz"
  sha256 "7196f5a624871c91ad051752ea21043c198a875189e08c70ab3167567a72889d"
  license "0BSD"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9213655cd67161b40fa5033414040718ca6fe3ac38cd83972e4718e98ddd121a"
    sha256 cellar: :any,                 arm64_ventura:  "8605ec59b64d396ee9ea203a0ee91cc306158e8a4ccbcd63bf2306ec464e9f09"
    sha256 cellar: :any,                 arm64_monterey: "26c5e478c43bfafd4c960d75e202682fd70af4d1ce0dd9be933bcfa30257edc2"
    sha256 cellar: :any,                 sonoma:         "e7a6c10c7673a9a6a54758f0733654295ecb25882ed70b14a4fe72af2bdde5a3"
    sha256 cellar: :any,                 ventura:        "f8f6a500978011019142ce9dc5d354074553359f6f69673fe0bd90c36458501c"
    sha256 cellar: :any,                 monterey:       "003fe8e4e3b16d1a98d3e030b0d91588dc60b8dc1f63a5909cbb3877805ac65d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "343104f1672be06cc2e32cf15aad3924aad7becb52dfd40a817d14515b22c1b5"
  end

  depends_on "oniguruma"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1300
  end

  on_linux do
    depends_on "acl"
    depends_on "libcap"
  end

  def install
    ENV.llvm_clang if OS.mac? && DevelopmentTools.clang_build_version <= 1300

    system "make", "release"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    touch "foo_file"
    touch "test_file"
    assert_equal "./test_file", shell_output("#{bin}/bfs -name 'test*' -depth 1").chomp
  end
end
