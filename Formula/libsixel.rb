class Libsixel < Formula
  desc "SIXEL encoder/decoder implementation"
  homepage "https://github.com/saitoha/sixel"
  url "https://github.com/libsixel/libsixel/archive/refs/tags/v1.10.3.tar.gz"
  sha256 "028552eb8f2a37c6effda88ee5e8f6d87b5d9601182ddec784a9728865f821e0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2e12a4b625632cd3eb3eeead931b300dbf743ea67d34e9ca046c56c70d260eed"
    sha256 cellar: :any,                 arm64_big_sur:  "ca3a3b1a9f9369271138c0e22d538e405b4804f481cd75cae2ce7b81bd02324d"
    sha256 cellar: :any,                 monterey:       "403618069640d51e6c2b6d32bdd909318668cef7878064054c64e67f9e8e3c5e"
    sha256 cellar: :any,                 big_sur:        "e47a3603e25d8f58593cb20438d1a49eae52a69660dedc06190bf67a7467c722"
    sha256 cellar: :any,                 catalina:       "ce396e62152d7ecb357d5a3c49254bd1c0ac446da262be84b7b76492dd25b440"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e16c474f371c89589255512c6e840080222b9388bb8eb9acd8252ca03567e68"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "jpeg"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, "..", "-Dgdk-pixbuf2=disabled", "-Dtests=disabled"
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    fixture = test_fixtures("test.png")
    system "#{bin}/img2sixel", fixture
  end
end
