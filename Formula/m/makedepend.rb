class Makedepend < Formula
  desc "Creates dependencies in makefiles"
  homepage "https://x.org/"
  url "https://xorg.freedesktop.org/releases/individual/util/makedepend-1.0.10.tar.xz"
  sha256 "f278c4686285d70292c03f7339cc3c0a811fc6c4bf9c053906d0a5732eac9138"
  license "MIT"

  livecheck do
    url "https://xorg.freedesktop.org/releases/individual/util/"
    regex(/href=.*?makedepend[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8931f9f30c9bf58f2d70db17cd2f09b12f8929f889754dad832cc3efb6e02433"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ae50c4cf4ef49c6993f39eb2871a81b8d6e08ea3ddb9f72dc4d8b574f75b09c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dcb8ce2569e66494d6ca189f3b0ca610376c79b296337bce3f000c07af418704"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ca3e07d463146fef1904b5a37d503d80c10d462bc0d32eda7b75e7bea295384"
    sha256 cellar: :any,                 arm64_linux:   "a4368853f4b3bc1068a9308d7cb756615b6105fb88102295440e49632a4a8a12"
    sha256 cellar: :any,                 x86_64_linux:  "83c5f9e10dc13ce498651d15a57534509d2dc64efed32f4fc19cea44bb0c3e76"
  end

  depends_on "pkgconf" => :build
  depends_on "util-macros"
  depends_on "xorgproto"

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    touch "Makefile"
    system bin/"makedepend"
  end
end
