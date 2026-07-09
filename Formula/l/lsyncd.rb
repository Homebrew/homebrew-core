class Lsyncd < Formula
  desc "Synchronize local directories with remote targets"
  homepage "https://github.com/lsyncd/lsyncd"
  url "https://github.com/lsyncd/lsyncd/archive/refs/tags/release-2.3.1.tar.gz"
  sha256 "fc19a77b2258dc6dbb16a74f023de7cd62451c26984cedbec63e20ff22bcbdd8"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "18d2ce09504c0dd1d8ab201be9ef3196f4906a2926223d2b51efd3d666448fd3"
    sha256 cellar: :any,                 arm64_sequoia: "eaffafdb4386a2998a8c76be07c21fa2a8ab16ed67a775ccd5f7098d6b9e7daa"
    sha256 cellar: :any,                 arm64_sonoma:  "7471d4a519c409f40759205f6058e4bcf0fad3289dd0d3fd13e86fd6cc276243"
    sha256 cellar: :any,                 sonoma:        "f078bb07533155c1ca980c3c1f1545790b1d49bc3208723776b3bc19e068e83d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d843b5de6cc97ad77fa3df196655fc4643fedf88c16bcdddd61c8dca2d134ebe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f469a4e9caafafadd1392475cf64b02bf2e84aa2dcdec1b1ddd7926249f07c6"
  end

  # https://github.com/lsyncd/lsyncd/issues/739
  # https://github.com/lsyncd/lsyncd/commit/724f077864989b3a2d401be3f73880175236e88b
  deprecate! date: "2026-05-17", because: :unmaintained
  disable! date: "2027-05-17", because: :unmaintained

  depends_on "cmake" => :build
  depends_on "lua@5.4"

  resource "xnu" do
    # From https://opensource.apple.com/releases/
    on_tahoe :or_newer do # 26.4
      url "https://github.com/apple-oss-distributions/xnu/archive/refs/tags/xnu-12377.101.15.tar.gz"
      sha256 "4dbb9c7538107c0411c2d6bf9ef16af3fd465af36fab031f53e4f53329a42723"
    end
    on_sequoia do # 15.6
      url "https://github.com/apple-oss-distributions/xnu/archive/refs/tags/xnu-11417.140.69.tar.gz"
      sha256 "6ec42735d647976a429331cdc73a35e8f3889b56c251397c05989a59063dc251"
    end
    on_sonoma do # 14.6
      url "https://github.com/apple-oss-distributions/xnu/archive/refs/tags/xnu-10063.141.1.tar.gz"
      sha256 "ffdc143cbf4c57dac48e7ad6367ab492c6c4180e5698cb2d68e87eaf1781bc48"
    end

    # No longer maintained macOS versions so should not need updates
    on_ventura do
      url "https://github.com/apple-oss-distributions/xnu/archive/refs/tags/xnu-8796.141.3.tar.gz"
      sha256 "f08bfe045a1fb552a6cbf7450feae6a35dd003e9979edf71ea77d1a836c8dc99"
    end
    on_monterey do
      url "https://github.com/apple-oss-distributions/xnu/archive/refs/tags/xnu-8020.140.41.tar.gz"
      sha256 "b11e05d6529806aa6ec046ae462d997dfb36a26df6c0eb0452d7a67cc08ad9e7"
    end
    on_big_sur do
      url "https://github.com/apple-oss-distributions/xnu/archive/refs/tags/xnu-7195.141.2.tar.gz"
      sha256 "ec5aa94ebbe09afa6a62d8beb8d15e4e9dd8eb0a7e7e82c8b8cf9ca427004b6d"
    end
    on_catalina :or_older do
      url "https://github.com/apple-oss-distributions/xnu/archive/refs/tags/xnu-6153.141.1.tar.gz"
      sha256 "886388632a7cc1e482a4ca4921db3c80344792e7255258461118652e8c632d34"
    end
  end

  def install
    args = ["-DCMAKE_INSTALL_MANDIR=#{man}"]
    if OS.mac?
      resource("xnu").stage buildpath/"xnu"
      args += %W[-DWITH_INOTIFY=OFF -DWITH_FSEVENTS=ON -DXNU_DIR=#{buildpath}/xnu]
    else
      args += %w[-DWITH_INOTIFY=ON -DWITH_FSEVENTS=OFF]
    end
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"lsyncd", "--version"
  end
end
