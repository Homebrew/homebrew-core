class Libxaw3d < Formula
  desc "X.Org: 3D Athena widget set based on the Xt library"
  homepage "https://www.x.org"
  url "https://xorg.freedesktop.org/archive/individual/lib/libXaw3d-1.6.6.tar.gz"
  sha256 "0cdb8f51c390b0f9f5bec74454e53b15b6b815bc280f6b7c969400c9ef595803"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "6096ca109060e0d44327e3f087cac26e96fdad05e1abaf75e072ececf6390fed"
    sha256 cellar: :any,                 arm64_sequoia:  "84926ca78b2283f5c32b42e003c4a6711d208aa2c0d31e81192816561e967830"
    sha256 cellar: :any,                 arm64_sonoma:   "2bcf584c0f4e7997ce9e72a452237f102eba55f0069565eb407f5fafe5d85fb5"
    sha256 cellar: :any,                 arm64_ventura:  "ee7c26268433917e585a7acc992c04abeac87d2954fe1a3d1e8978e1d89d3832"
    sha256 cellar: :any,                 arm64_monterey: "906cc60ffd7998219e6cd38bfd86e9331193ac7cc38ec5557a751a5d76c60f91"
    sha256 cellar: :any,                 sonoma:         "7c63814a4ba44cd9b855922ae73e393fe8d1c75e74451b26de218cf790fffe2d"
    sha256 cellar: :any,                 ventura:        "813b0a28985d4942c631d31e26c6135bca92a88652aa6c634cd92b957dcbce61"
    sha256 cellar: :any,                 monterey:       "57849f92c0f2cdd938b95d8c0f7aec3f8b1c5c8d06211a290c3112b67b212b78"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "06d7e75d366e78189c6669037314423a41ef33afb196d4f503017739f6ec5704"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce52f2da8dd74a3df5d277ffeb678f86a9572b0c52a29e513aa688d37e704210"
  end

  depends_on "pkgconf" => :build
  depends_on "util-macros" => :build
  depends_on "libx11"
  depends_on "libxext"
  depends_on "libxmu"
  depends_on "libxpm"
  depends_on "libxt"

  # Backport fix for improved linking on macOS
  patch do
    on_macos do
      url "https://gitlab.freedesktop.org/xorg/lib/libxaw3d/-/commit/b2365950e5314b0453dd7cf2a552aa30ec19c046.diff"
      sha256 "18919b30bfafd2642895a4f9497f54b8d263e4eb593f192a923340732ed4afa8"
    end
  end

  def install
    args = %W[
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-silent-rules
      --enable-gray-stipples
      --enable-arrow-scrollbars
      --enable-multiplane-bitmaps
    ]

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <X11/Xaw3d/Label.h>
      int main() { printf("%d", sizeof(LabelWidget)); }
    C
    system ENV.cc, "test.c", "-o", "test"
    output = shell_output("./test").chomp
    assert_match "8", output
  end
end
