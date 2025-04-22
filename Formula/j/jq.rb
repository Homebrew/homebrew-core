class Jq < Formula
  desc "Lightweight and flexible command-line JSON processor"
  homepage "https://jqlang.github.io/jq/"
  url "https://github.com/jqlang/jq/releases/download/jq-1.7.1/jq-1.7.1.tar.gz"
  sha256 "478c9ca129fd2e3443fe27314b455e211e0d8c60bc8ff7df703873deeee580c2"
  license "MIT"

  livecheck do
    url :stable
    regex(/^(?:jq[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "a10c82b07e393869d4467ad3e8ba26346d026b1ad3533d31dbb5e72abe9a7968"
    sha256 cellar: :any,                 arm64_sonoma:   "7d01bc414859db57e055c814daa10e9c586626381ea329862ad4300f9fee78ce"
    sha256 cellar: :any,                 arm64_ventura:  "b1a185e72ca020f08a8de22fabe1ad2425bf48d2e0378c5e07a6678020fa3e15"
    sha256 cellar: :any,                 arm64_monterey: "8f8c06332f413f5259b360ed65dc3ef21b5d3f2fff35160bc12367e53cbd06bf"
    sha256 cellar: :any,                 sonoma:         "6bc01de99fd7f091b86880534842132a876f2d3043e3932ea75efc5f51c40aea"
    sha256 cellar: :any,                 ventura:        "03227348d3845fe16ed261ad020402c1f23c56e73f65799ce278af4bac63c799"
    sha256 cellar: :any,                 monterey:       "25aab2c539a41e4d67cd3d44353aac3cdd159ea815fec2b8dd82fbf038c559cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "843a48d2e76247b33f28189973245dffb356459ff019e5721b4c8ab4f374befa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9559d8278cf20ad0294f2059855e1bc9d2bcabfd2bd5b5774c66006d1f201ad8"
  end

  head do
    url "https://github.com/jqlang/jq.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "oniguruma"

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--disable-maintainer-mode"
    system "make", "install"
  end

  test do
    assert_equal "2\n", pipe_output("#{bin}/jq .bar", '{"foo":1, "bar":2}')
  end
end
