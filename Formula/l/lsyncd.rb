class Lsyncd < Formula
  desc "Synchronize local directories with remote targets"
  homepage "https://github.com/lsyncd/lsyncd"
  url "https://github.com/lsyncd/lsyncd/archive/refs/tags/release-2.3.1.tar.gz"
  sha256 "fc19a77b2258dc6dbb16a74f023de7cd62451c26984cedbec63e20ff22bcbdd8"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "b1de715ecf63cc59a9f4725b7800e039d417d297dbaf6a8f3643d95979dc1cfd"
    sha256 cellar: :any,                 arm64_sonoma:   "815e36a145bfecbd20023f55bd910b2223cb54a39c51e276a97ee19f717a1c94"
    sha256 cellar: :any,                 arm64_ventura:  "eaf1cd2a7576eed88ab68e26b93b234132a1cf9e6ddf63f0883fa0b859fb798f"
    sha256 cellar: :any,                 arm64_monterey: "e4ed253d0a0792a3c2e22f82a40c1627a8fcb6c15ed62f62cca24b1b965fdc81"
    sha256 cellar: :any,                 arm64_big_sur:  "e818e3e8cafb4f9d8cf82f6ec29b8d247b2e17276f92f9e8bef9364f740fca85"
    sha256 cellar: :any,                 sonoma:         "2d6b3bc50d43c3de3cfc0cdc104a4a69570f7b13465aecbb478006ef6e2bda75"
    sha256 cellar: :any,                 ventura:        "36f5613aab337d30135d232e5abf5bc5baa63470537cbaa7917fd202fdf45b3e"
    sha256 cellar: :any,                 monterey:       "453140f96382bf6eb4b4ecc9df475ef25ea690f27a870f0b457619d0fc15a69c"
    sha256 cellar: :any,                 big_sur:        "c221932f57a2ddbda8c4722cbd4c547244fd4492a1eb46959aea03244897566f"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "ed00787f9706cd469cc6314c2af9edf287432a308870c52f0cb46347009952bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de8ec6eb7f7122c422cb82bf5c1f1051ce23bde9dc48bb2327da7dca1573f757"
  end

  depends_on "cmake" => :build
  depends_on "lua"

  resource "xnu" do
    # From https://opensource.apple.com/releases/
    on_sonoma :or_newer do
      url "https://github.com/apple-oss-distributions/xnu/archive/refs/tags/xnu-10002.41.9.tar.gz"
      sha256 "f158a10e01702aa59a90af60ab097c3253123ab3f05d9953530730d241a9cba4"
    end
    on_ventura do
      url "https://github.com/apple-oss-distributions/xnu/archive/refs/tags/xnu-8792.61.2.tar.gz"
      sha256 "61c5758d4423ede45e3cbe70b4316d982af59dc91fc482cd9afc145b2ad2226a"
    end
    on_monterey do
      url "https://github.com/apple-oss-distributions/xnu/archive/refs/tags/xnu-8020.140.41.tar.gz"
      sha256 "b11e05d6529806aa6ec046ae462d997dfb36a26df6c0eb0452d7a67cc08ad9e7"
    end
    on_big_sur do
      url "https://github.com/apple-oss-distributions/xnu/archive/refs/tags/xnu-7195.141.2.tar.gz"
      sha256 "ec5aa94ebbe09afa6a62d8beb8d15e4e9dd8eb0a7e7e82c8b8cf9ca427004b6d"
    end
    on_catalina do
      url "https://github.com/apple-oss-distributions/xnu/archive/refs/tags/xnu-6153.141.1.tar.gz"
      sha256 "886388632a7cc1e482a4ca4921db3c80344792e7255258461118652e8c632d34"
    end
    on_mojave do
      url "https://github.com/apple-oss-distributions/xnu/archive/refs/tags/xnu-4903.270.47.tar.gz"
      sha256 "099c1c50c4cef4db5fcf4df6a6314498693ad52ed5e813201e2cf442e22985fe"
    end
    on_high_sierra do
      url "https://github.com/apple-oss-distributions/xnu/archive/refs/tags/xnu-4570.71.2.tar.gz"
      sha256 "b9e2c84c3ee62819917d3bc845e10c2f4bde1194e731c192b6cf0239da5a5a14"
    end
    on_sierra do
      url "https://github.com/apple-oss-distributions/xnu/archive/refs/tags/xnu-3789.70.16.tar.gz"
      sha256 "0bc4cf425513dd16f3032f189d93cdb6bef48696951bd2e5bf4878dacdcd10d2"
    end
    on_el_capitan :or_older do
      url "https://github.com/apple-oss-distributions/xnu/archive/refs/tags/xnu-3248.60.10.tar.gz"
      sha256 "a4f646c6d34814df5a729a2c0b380c541dd5282b5d82e35e31bf66c034c2b761"
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
