class Lndir < Formula
  desc "Create a shadow directory of symbolic links to another directory tree"
  homepage "https://gitlab.freedesktop.org/xorg/util/lndir"
  url "https://www.x.org/releases/individual/util/lndir-1.0.5.tar.xz"
  sha256 "3b65577a5575cce095664f5492164a96941800fe6290a123731d47f3e7104ddb"
  license "MIT-open-group"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "975d212727bfab2bbd984d471dd118acb1c435f96c766aa04c4e6252a5822004"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "c4ac20b2d9c5af28a153829cb9f890628143e5d025e6c45c1d41553f9e060b79"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b81f2833d3ba3403ff4827293c28af1770b455766d407f4541c9b950b8298085"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d0c6d45c23ed0b7b0db075165b1d86ee34add3e07c60149d2153dd57987a1a2e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5de50a05e4ae19512b58bcda8dc8552f9fa4c6cc62dcedd928b583b0638c5d8b"
    sha256 cellar: :any_skip_relocation, sonoma:         "0775ac61f0fa93c88554dc25c9e0f040fca75acb151b1cdc93b08004c6ee633c"
    sha256 cellar: :any_skip_relocation, ventura:        "375be2c049506f9b438a76ebb32e971d7cc481d5be857ab94052ccfc93f185bf"
    sha256 cellar: :any_skip_relocation, monterey:       "b2ee287f8e0a07e6afb468a63ae4a053a532620fcf78348bc9363de5bc9969a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "7ed64c18f82fc9ab722824a0090e4feffc0bec9a8eb1f2f85876e6fc41485f0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ecf4313dfc583a1197e94925c502cdfe08d777e5aead7dd44bc3ab360f9c8b3d"
  end

  depends_on "pkgconf" => :build
  depends_on "xorgproto"  => :build

  def install
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    mkdir "test"
    system bin/"lndir", bin, "test"
    assert_path_exists testpath/"test/lndir"
  end
end
