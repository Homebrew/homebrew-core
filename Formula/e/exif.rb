class Exif < Formula
  desc "Read, write, modify, and display EXIF data on the command-line"
  homepage "https://libexif.github.io/"
  url "https://github.com/libexif/exif/releases/download/exif-0_6_22-release/exif-0.6.22.tar.xz"
  sha256 "0fe268736e0ca0538d4af941022761a438854a64c8024a4175e57bf0418117b9"
  license "LGPL-2.1-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "bfb1b7b9782dd4c888442a3dc2d6872894e1acfde781fc8b819e631fd1f4ed23"
    sha256 cellar: :any,                 arm64_sequoia:  "f6cbeebd5b8041e6b8ce190a02911e9c53a0079648a35bcd7c279372cbef4afa"
    sha256 cellar: :any,                 arm64_sonoma:   "16650f088870ad4c8f97b7f9e5fcf49eb170409c90c59a4dd07979eaebd463bd"
    sha256 cellar: :any,                 arm64_ventura:  "834b4812f8e8828a2e6b274730df66ea88a093fd1342a45931f71e954fa07d0c"
    sha256 cellar: :any,                 arm64_monterey: "17692fb4a47365f4828c8dd22eb29e10f38fdb53e9eaeab0bb4bb06b86d9f8fd"
    sha256 cellar: :any,                 arm64_big_sur:  "6f8bd97c2b520c9ca089a39d2ae293f37e15a8049880c308a6413f295ef8b3fe"
    sha256 cellar: :any,                 sonoma:         "3c655100531630bc28a4c7b09b37f4791395cae06446a34700343a22cd3824c5"
    sha256 cellar: :any,                 ventura:        "13a54ab17d7c7abd2604ec6f6b092051f587fbf5cf404ac8aa3cba3a5d8ef238"
    sha256 cellar: :any,                 monterey:       "e425f56e4fb8d296c47622010d341caf47e586e9ceeffd110d181598f80839df"
    sha256 cellar: :any,                 big_sur:        "9603f2b9c8b5efc9a83e2a9fb5b89fe2b4954567c39e814c2a8b81735c824063"
    sha256 cellar: :any,                 catalina:       "3d4f3d7c86e7c112f9164970cb5e283a96d82235c1633f15de6683b04ec7df87"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "df114ade71a7d16168b5416d7b649c109477e4815f73933d814cdcd3b884f76d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a41aa53dd457e0318526a6ec043f18ff97a8a23a9009e0a556c271d0eae14d09"
  end

  depends_on "pkgconf" => :build
  depends_on "libexif"
  depends_on "popt"

  def install
    args = %w[
      --disable-silent-rules
      --disable-nls
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    test_image = test_fixtures("test.jpg")
    assert_match "The data supplied does not seem to contain EXIF data.",
                 shell_output("#{bin}/exif #{test_image} 2>&1", 1)
  end
end
