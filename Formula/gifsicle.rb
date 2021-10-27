class Gifsicle < Formula
  desc "GIF image/animation creator/editor"
  homepage "https://www.lcdf.org/gifsicle/"
  url "https://www.lcdf.org/gifsicle/gifsicle-1.93.tar.gz"
  sha256 "92f67079732bf4c1da087e6ae0905205846e5ac777ba5caa66d12a73aa943447"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e566d5e1a954201d5adf69c8eceba9c9bb037e8bc84a9fc36afc63b099c5e2e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ad499b676a6a5e433964de6303f658838239c09b69e02ce2db62b6c5ffc1a017"
    sha256 cellar: :any_skip_relocation, monterey:       "1dd2da2246eef8dcbd3297adc1db453906e22cf08b07e6007b2ba3293eeb3051"
    sha256 cellar: :any_skip_relocation, big_sur:        "75b269e600f8b3446694828d579f4425cfc1c49142e05441a902cdc48c39e143"
    sha256 cellar: :any_skip_relocation, catalina:       "88ac00c8f5e523b04db223a555a0094c62e30c05760ed9abcc5d0f3aef676686"
    sha256 cellar: :any_skip_relocation, mojave:         "383bac8506db87f8b84afc628ceac00fb168f2d1bb062d4aa77f7644e2c21c27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b528fa87110fdcb96e4557409a1c4cccc507e9b4d87288f280a0828b874b27e"
  end

  head do
    url "https://github.com/kohler/gifsicle.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  conflicts_with "giflossy",
    because: "both install an `gifsicle` binary"

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
    system "#{bin}/gifsicle", "--info", test_fixtures("test.gif")
  end
end
