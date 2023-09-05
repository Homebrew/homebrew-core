class HicolorIconTheme < Formula
  desc "Fallback theme for FreeDesktop.org icon themes"
  homepage "https://wiki.freedesktop.org/www/Software/icon-theme/"
  url "https://icon-theme.freedesktop.org/releases/hicolor-icon-theme-0.17.tar.xz"
  sha256 "317484352271d18cbbcfac3868eab798d67fff1b8402e740baa6ff41d588a9d8"
  license all_of: ["FSFUL", "FSFULLR", "GPL-2.0-only", "X11"]

  livecheck do
    url :homepage
    regex(/href=.*?hicolor-icon-theme[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fca72dd306b23edae0d4d66b0bd485e66f53f175ba1ca87a6167309d73533bc8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1153e436e03439c74a2eae87b6b5fbb6c8192607420dd5b01d0295a8ef29d2e5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "16e984b4dc9809fb223592f9b2c8a45cc49e796bd3b03f0b9507e80953167292"
    sha256 cellar: :any_skip_relocation, ventura:        "fca72dd306b23edae0d4d66b0bd485e66f53f175ba1ca87a6167309d73533bc8"
    sha256 cellar: :any_skip_relocation, monterey:       "1153e436e03439c74a2eae87b6b5fbb6c8192607420dd5b01d0295a8ef29d2e5"
    sha256 cellar: :any_skip_relocation, big_sur:        "f4cd50751f22d1aae6156ce3e552dbe0afb21ce1aaa5a7cc7ce284c867a20865"
    sha256 cellar: :any_skip_relocation, catalina:       "8ba8d6065b652396583c55a0e73cff0007f96064a330ac20499ff1d887771eb8"
    sha256 cellar: :any_skip_relocation, mojave:         "5ba4bb6a7e89f5fb0d43504d68d657a536be9540d4cc72552bd5965e15a82b91"
    sha256 cellar: :any_skip_relocation, high_sierra:    "b33f58b98a6ca6bb72777eaf7b7a4bb393d5cc9ced6954dd7a7e52e18c214799"
    sha256 cellar: :any_skip_relocation, sierra:         "cd8699f3944eb87b76fc89e4ca69f19df5d66aa8a4c89d636660d299e807f5b0"
    sha256 cellar: :any_skip_relocation, el_capitan:     "cd8699f3944eb87b76fc89e4ca69f19df5d66aa8a4c89d636660d299e807f5b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1153e436e03439c74a2eae87b6b5fbb6c8192607420dd5b01d0295a8ef29d2e5"
  end

  head do
    url "https://gitlab.freedesktop.org/xdg/default-icon-theme.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    args = %W[--prefix=#{prefix} --disable-silent-rules]
    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end
    system "make", "install"
  end

  test do
    assert_predicate share/"icons/hicolor/index.theme", :exist?
  end
end
