class Lndir < Formula
  desc "Create a shadow directory of symbolic links to another directory tree"
  homepage "https://gitlab.freedesktop.org/xorg/util/lndir"
  url "https://www.x.org/releases/individual/util/lndir-1.0.4.tar.xz"
  sha256 "3e3437a9d3bb377755dd04a2c90d4c014d9fe90987ff73450bf5b8d161795e87"
  license "MIT-open-group"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a5c7d4f242366bf8afbf3809b78990ce87a799cdc488fc355be66234db59b050"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ea6bce461d8190d2bae28551e5e69dab707e32b1ca6ab819357cb5fabee6bc3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "06b4a47c1037873c6ac8c672feb55d1642b731fc8b80ab176a6c527a6f433d47"
    sha256 cellar: :any_skip_relocation, ventura:        "5b2b016409ca45aa7d5b791083149ad6c6413e31be5ab26ea1e0fe273f509487"
    sha256 cellar: :any_skip_relocation, monterey:       "20bcdd3644f291c4d2f8db100b767c7b30f6c5e8d0a758ad83197d7b9aa2d44a"
    sha256 cellar: :any_skip_relocation, big_sur:        "2c946743e35996f67404220ded67d5f82a9ef6913ad63cf0a8f9cc79d6b4fd9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7d07d2eb839baf3a80d5980b864ff61a7f2e8c095dc2d3add559837aad49eeb"
  end

  depends_on "pkg-config" => :build
  depends_on "xorgproto"  => :build

  def install
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    mkdir "test"
    system bin/"lndir", bin, "test"
    assert_predicate testpath/"test/lndir", :exist?
  end
end
