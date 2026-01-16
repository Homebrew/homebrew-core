class Gifsicle < Formula
  desc "GIF image/animation creator/editor"
  homepage "https://www.lcdf.org/gifsicle/"
  url "https://www.lcdf.org/gifsicle/gifsicle-1.96.tar.gz"
  sha256 "fd23d279681a6dfe3c15264e33f344045b3ba473da4d19f49e67a50994b077fb"
  license "GPL-2.0-only"

  livecheck do
    url :homepage
    regex(/href=.*?gifsicle[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "33c1243bdc845aa74b15f5e89eb46be030360140687dca87a06eebb30b8d0308"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75b564ba2a3671f341b02b63b0a8429ea02db301a6ecf1ab346a31d158f44139"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90eddb31b7d51d074eb66c11a6f7dcbb39e086adf5fa37465e3d6c53f7eb9790"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bddb0e3c75d143311b6d718302aa0aaa73c2ffa7dec3506087c3302d1397c09e"
    sha256 cellar: :any_skip_relocation, sonoma:        "fddb207d04bf9452a711aa8fdfad464e8a11ced975329263f41025abf1dfaa5c"
    sha256 cellar: :any_skip_relocation, ventura:       "19fe7f8c9fc05b0998a762d8b57d4736d858e56a24e97b4f23078ab17bbd1e9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b41540353a764c3307806e38aa2f3e8d0a7e1af16dd3366e277d6361f0919d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1e4342a1be7ae45ff3d7edacfdaee5f4f57753835353ad86e0dc5b3c528e302"
  end

  head do
    url "https://github.com/kohler/gifsicle.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-gifview
    ]

    system "./bootstrap.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"gifsicle", "--info", test_fixtures("test.gif")
  end
end
