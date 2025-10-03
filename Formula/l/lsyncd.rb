class Lsyncd < Formula
  desc "Synchronize local directories with remote targets"
  homepage "https://github.com/lsyncd/lsyncd"
  url "https://github.com/lsyncd/lsyncd/archive/refs/tags/release-2.3.1.tar.gz"
  sha256 "fc19a77b2258dc6dbb16a74f023de7cd62451c26984cedbec63e20ff22bcbdd8"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "508c60c1a56dc5267e6c49781c0aaddb91767c26e926dd530a29689d8fd3cf96"
    sha256 cellar: :any,                 arm64_sequoia: "af0f38eb7372e1a10d57e9fb2f36af97e57e9cbe84f89c1de6b80be612fab7ee"
    sha256 cellar: :any,                 arm64_sonoma:  "f9c9bc6d091e4e9a996157fa6f0ca50f384866f876e91c0c0dec930c61b9791c"
    sha256 cellar: :any,                 sonoma:        "8cdbd9130e3d1b8fe3b815b6806e2505bfed27ee5bbb402e4fecdb26c7c93cff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e67dd091044e053e1b1eed87fcddaf7549cf2eee8c6c9c1c5740ae8c3213823c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6560108e0b00e2ea9ecf9fa954fb584b280e6dbb794b0e36f03a29a2b04705ab"
  end

  depends_on "cmake" => :build
  depends_on "lua"

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
