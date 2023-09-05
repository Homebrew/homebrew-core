class Clens < Formula
  desc "Library to help port code from OpenBSD to other operating systems"
  homepage "https://github.com/conformal/clens"
  url "https://github.com/conformal/clens/archive/CLENS_0_7_0.tar.gz"
  sha256 "0cc18155c2c98077cb90f07f6ad8334314606c4be0b6ffc13d6996171c7dc09d"
  license "ISC"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e42ef7f7f467d0bbe324659c9fe2a89c0049968a580bd1115d93a8423af0fe1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "513fdfc8d9f7c710d81ade46ff26f9d74283c096029c55c99282e03682ffba97"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6e62d3fb708d1585bda7aeef47488d5b765a7b3af5bba0e2d2544a12b08cb892"
    sha256 cellar: :any_skip_relocation, ventura:        "930fc11da5b772ab93d361d1172b0cf4c2b0abc44c2f9acdeb7f37b5f6be17f5"
    sha256 cellar: :any_skip_relocation, monterey:       "4e55d83091142894a16911836b98bd00e4188720709eb4c5fdc8203442d57097"
    sha256 cellar: :any_skip_relocation, big_sur:        "602ace92e6b121b004a43a851209b95b0769bc84d9ea0c7725f29f3d2531324f"
    sha256 cellar: :any_skip_relocation, catalina:       "fef1ad76413e8e15683a4066276ed7f37f821edcbda4e6d648bd60e09a33a30d"
    sha256 cellar: :any_skip_relocation, mojave:         "3550adf8f1e9eb8e62ac6c64f3b3c8cae0fba0d0f958f6e6da99e74f4e4d5e19"
    sha256 cellar: :any_skip_relocation, high_sierra:    "e9dfe6e9228a928f9cb1a4048d92ec576be5f89f48408401b7f3020c1482a7c6"
    sha256 cellar: :any_skip_relocation, sierra:         "f034c79bf5a16265db249c673b2d2a3e6850676dba739adeb6e90394d8f77475"
    sha256 cellar: :any_skip_relocation, el_capitan:     "f6c68d7dce9d824274e16e3867926528cc79d161418fac0a0052e37dc6604668"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b5d5f5cba941676c726e09e2b14c9069dfebf9db9d6cb2b75fc321a2481aedf"
  end

  on_linux do
    depends_on "libbsd"
  end

  patch do
    url "https://github.com/conformal/clens/commit/83648cc9027d9f76a1bc79ddddcbed1349b9d5cd.patch?full_index=1"
    sha256 "c70833eff6f98eab6166e9c341bb444eae542617f4937a29514fe5c6bbd3d8b0"
  end

  def install
    ENV.deparallelize
    system "make", "all", "install", "LOCALBASE=#{prefix}"
  end
end
