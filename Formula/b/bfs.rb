class Bfs < Formula
  desc "Breadth-first version of find"
  homepage "https://tavianator.com/projects/bfs.html"
  url "https://github.com/tavianator/bfs/archive/3.0.2.tar.gz"
  sha256 "d3456a9aeecc031064db0dbe012e55a11eb97be88d0ab33a90e570fe66457f92"
  license "0BSD"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6986bfa3c03893b6342d80df953cf65e0ec3f656a51d54998808ab505a7455ae"
    sha256 cellar: :any,                 arm64_ventura:  "7148376fded74fd3657a1add436bac7c753a953794ea3daa9f8e89c9da141f53"
    sha256 cellar: :any,                 arm64_monterey: "87f5f4edc4ea7672d220743758cb92821c2c0675bdaaf14550ea70924ade5c6f"
    sha256 cellar: :any,                 arm64_big_sur:  "de40684b24ba7995138f33890a833f2868511b0afbed17b448f552c5da3f9eb3"
    sha256 cellar: :any,                 sonoma:         "cb5ebe63127b821b492859878d5563c17ddc039aea2f41e7808bb96ba9cf4c93"
    sha256 cellar: :any,                 ventura:        "4a4fc4a38a622394f37d7da8495c6d40179cf775cc551a764ada1cb70c35148a"
    sha256 cellar: :any,                 monterey:       "f9abfddbadbc56ed5c6649a151974af6664886808a594b4092a4114589d9c14b"
    sha256 cellar: :any,                 big_sur:        "6ae258f53edb86846f69be682e1b3d28000b11efa7d015373ca6e91c4c96f744"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "070992b0d08308cdc650e24db2827b0218bfe6f0bb36483a41d32a23b944a71d"
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
