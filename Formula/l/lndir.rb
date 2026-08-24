class Lndir < Formula
  desc "Create a shadow directory of symbolic links to another directory tree"
  homepage "https://gitlab.freedesktop.org/xorg/util/lndir"
  url "https://www.x.org/releases/individual/util/lndir-1.0.6.tar.xz"
  sha256 "18f6d664e52894b7dee0d2fc9b171e0e58566e5091e44f9535f10e6d941912a4"
  license "MIT-open-group"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f01cd44849addd2936024e18d9a686575cc77661c94538a0e730a2885db5906"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c14db1ae293bad13d546561df38fb953607a0a3932956b2b2404617d3b05bbb4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ba398b941388dec3edc8cef206ace2cb974d60dbc85f3071b390f8c63fcf059"
    sha256 cellar: :any_skip_relocation, sonoma:        "10af485c6b8824b569fef29e655f7e2096266992c334a177390413a3aba44bba"
    sha256 cellar: :any,                 arm64_linux:   "3469420543dc492dd477f38f43b87b888239d6cd82ec76819ce15b8ab7b2eecb"
    sha256 cellar: :any,                 x86_64_linux:  "4a30636cde435095a78ca552936657217220d9d99d6b24f13513c0f8f6bfe333"
  end

  depends_on "pkgconf" => :build
  depends_on "xorgproto"  => :build

  def install
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    mkdir "test"
    system bin/"lndir", bin, "test"
    assert_path_exists testpath/"test/lndir"
  end
end
