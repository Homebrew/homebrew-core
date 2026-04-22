class Lsyncd < Formula
  desc "Synchronize local directories with remote targets"
  homepage "https://github.com/lsyncd/lsyncd"
  url "https://github.com/lsyncd/lsyncd/archive/refs/tags/release-2.3.1.tar.gz"
  sha256 "fc19a77b2258dc6dbb16a74f023de7cd62451c26984cedbec63e20ff22bcbdd8"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "da28ce3ac9d2171449adf629c00e7534e8d7309b30c656d2f143802b8d21c9ae"
    sha256 cellar: :any,                 arm64_sequoia: "59bea69517848816c960b8fa3dfd089ac2bb297bd549579fa1d98f6e3b67c6d6"
    sha256 cellar: :any,                 arm64_sonoma:  "67dcb602a07b2c3ad6638b51cdf15d6af57d7d7bb7ec9dc2db9903da37ac93ef"
    sha256 cellar: :any,                 sonoma:        "0c11103090d25b5d5aff2a0674439ded937b0e79cc9328fcf3c306fc1ee28d62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a7b53aa9e756a873482e88be4e085240b285901a359f79924226ea82ca27fe8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "515ce4cedcf728c4b540bb488e2c15145bb6bce49c83370f82cbffdd9b5511bc"
  end

  depends_on "cmake" => :build
  depends_on "lua@5.4"

  resource "xnu" do
    # From https://opensource.apple.com/releases/
    on_sequoia :or_newer do
      url "https://github.com/apple-oss-distributions/xnu/archive/refs/tags/xnu-11417.140.69.tar.gz"
      sha256 "6ec42735d647976a429331cdc73a35e8f3889b56c251397c05989a59063dc251"
    end
    on_sonoma do
      url "https://github.com/apple-oss-distributions/xnu/archive/refs/tags/xnu-10063.141.1.tar.gz"
      sha256 "ffdc143cbf4c57dac48e7ad6367ab492c6c4180e5698cb2d68e87eaf1781bc48"
    end
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
