class Mp4v2 < Formula
  desc "Read, create, and modify MP4 files"
  homepage "https://mp4v2.org"
  url "https://github.com/enzo1982/mp4v2/releases/download/v2.1.3/mp4v2-2.1.3.tar.bz2"
  sha256 "033185c17bf3c5fdd94020c95f8325be2e5356558e3913c3d6547a85dd61f7f1"
  license "MPL-1.1"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "bf656d8a485b0663a730368ad755d921f3456ceeca347501c8cbcc401c63bbc6"
    sha256 cellar: :any,                 arm64_sequoia:  "1a2c9a7beb75abcc15327b7b7437a831ae61855cc781e1200d11a4c1cf34a299"
    sha256 cellar: :any,                 arm64_sonoma:   "e9bc1800a60417f19d19347569285480d631355b615ad520d2b5c4f28b219d28"
    sha256 cellar: :any,                 arm64_ventura:  "1eeebb5c4beeda316aec2ab260c37b2eb7375330af16ff7f80a5e63f61ca7042"
    sha256 cellar: :any,                 arm64_monterey: "ab285946431ba3b30e0541a5391ff4ae0af7fa6ec6d84bd3213ac34400bf4682"
    sha256 cellar: :any,                 arm64_big_sur:  "48b40608f388870c825a0655c317293927d37899fc412c73c998cb3db60b1670"
    sha256 cellar: :any,                 sonoma:         "59d2e7c940d983d7f291230b93df803ab99ae9834a40adec08d77be60e05f858"
    sha256 cellar: :any,                 ventura:        "5f584150ea02e3b5d3049a117b60dbe88d412c380442fef8246267bf6f66ed36"
    sha256 cellar: :any,                 monterey:       "62619da0d20b36b5854c08f531687dfe55d9fbd87dabaaf985ced7fe1b24b3aa"
    sha256 cellar: :any,                 big_sur:        "c7c93618a03cfb59e95a6d39e9e6e9d1f355b72ea199b9c6e3d881f606323c88"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "01e24f92ce3d4edfeb7bd53fcb063d6bae8152ccc74f50a8be0ea98f8bb2bee9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "529cebb9ec595d2834e29ff7be7a29150453be53b55a1269284992cd8c35de06"
  end

  conflicts_with "bento4",
    because: "both install `mp4extract` and `mp4info` binaries"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
    system "make", "install-man"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mp4art --version")
  end
end
