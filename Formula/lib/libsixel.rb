class Libsixel < Formula
  desc "SIXEL encoder/decoder implementation"
  homepage "https://github.com/saitoha/sixel"
  url "https://github.com/libsixel/libsixel/archive/refs/tags/v1.10.3.tar.gz"
  sha256 "028552eb8f2a37c6effda88ee5e8f6d87b5d9601182ddec784a9728865f821e0"
  revision 1
  head "https://github.com/libsixel/libsixel.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "22e14314971f7e675545480da01b9b9d32ffb8109f71520071dfe88f82504455"
    sha256 cellar: :any,                 arm64_monterey: "056f4c105631db9ec5d1ac420ec491a51a130c03707147d5962383611d4d4aba"
    sha256 cellar: :any,                 arm64_big_sur:  "6742e20e9eef3d16fd501c327abe0ceb535089eea12e07d6ad7a736ff6766400"
    sha256 cellar: :any,                 ventura:        "c5e4d246b66f25372775f0db1cdf79a1e509f509bf66b5cf04185e5e30e6a32f"
    sha256 cellar: :any,                 monterey:       "43658b6a576c0792e99734ef9d82e9a9d767fddeaf86e4f7c724cd21ee941746"
    sha256 cellar: :any,                 big_sur:        "920afd79faa01b7ec960901564a0b38e466ac9a7a29f7742be1d452c83b5e4f3"
    sha256 cellar: :any,                 catalina:       "1e2c787edf46446c7fd9b40313dc2a72fe8dfa681030d0cf2f213568e8ea460d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f496efefbc5166488888d41e05cbdef0d9c581d152d6c79181a1bdffd0f36ff7"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"

  def install
    system "meson", *std_meson_args, "build", "-Dgdk-pixbuf2=disabled", "-Dtests=disabled"
    system "meson", "compile", "-C", "build", "-v"
    system "meson", "install", "-C", "build"
  end

  test do
    fixture = test_fixtures("test.png")
    system "#{bin}/img2sixel", fixture
  end
end
