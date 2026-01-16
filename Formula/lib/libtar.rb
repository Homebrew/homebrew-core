class Libtar < Formula
  desc "C library for manipulating POSIX tar files"
  homepage "https://repo.or.cz/libtar.git"
  url "https://repo.or.cz/libtar.git",
      tag:      "v1.2.20",
      revision: "0907a9034eaf2a57e8e4a9439f793f3f05d446cd"
  license "NCSA"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:    "b2724a26b82c1a3567c55b318884a020858a64f1419e2e7991062b3ab49950fa"
    sha256 cellar: :any,                 arm64_sequoia:  "4c4e12298ea2527d81b280592e4442f703eb59473e9b22c171ca70be11c90575"
    sha256 cellar: :any,                 arm64_sonoma:   "63c312ae75aea7e67be7285c6abb9a34ce0079fd4a9629f02c48fe23fb0a6ca0"
    sha256 cellar: :any,                 arm64_ventura:  "5b5d861d3e7a24bfbb41d37e9ab4efe883e9f9403d01b6dc1509480f23f7f80f"
    sha256 cellar: :any,                 arm64_monterey: "02f257866b2d60bc629d5c35f70f41889ab2254de7f29533ab01d600979d74c2"
    sha256 cellar: :any,                 arm64_big_sur:  "7481da1834936b6237f152fe8b7e22196ad5c76833af39c9e9f74eae6347c9a5"
    sha256 cellar: :any,                 sonoma:         "717ef919c46b1fbbffe066be73a93a8a5ae3cc1bfaa25cf4410d8c55970169b9"
    sha256 cellar: :any,                 ventura:        "d0e2280e4245eda925984747db9ef07b712ccf5e6de713ccc35289e7c6c01c42"
    sha256 cellar: :any,                 monterey:       "de9f3cf843c333e94657378a4b551386f81fe9f3afef5b69539de108330c3c4b"
    sha256 cellar: :any,                 big_sur:        "7424cf8229c7aea825592a76227da3355f32a43b9fbc5e140a0cf1eb07d05c8e"
    sha256 cellar: :any,                 catalina:       "35617f312e3c6fb1e473a5d20a559dcbd1815544bdd99c95419ac7e6e8abf9f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "b1baa2051a67e4aff529c5a69ff529914422e2abd2c917d813929e915e633991"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5703c44aa7e1572385af551d05f17bafccf9a247eef56639a58dafd5aa8bdd46"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  uses_from_macos "zlib"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--mandir=#{man}", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"homebrew.txt").write "This is a simple example"
    system "tar", "-cvf", "test.tar", "homebrew.txt"
    rm "homebrew.txt"
    refute_path_exists testpath/"homebrew.txt"
    assert_path_exists testpath/"test.tar"

    system bin/"libtar", "-x", "test.tar"
    assert_path_exists testpath/"homebrew.txt"
  end
end
