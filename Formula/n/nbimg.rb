class Nbimg < Formula
  desc "Smartphone boot splash screen converter for Android and winCE"
  homepage "https://github.com/poliva/nbimg"
  url "https://github.com/poliva/nbimg/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "f72846656bb8371564c245ab34550063bd5ca357fe8a22a34b82b93b7e277680"
  license "GPL-3.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "dd7fbd304d9f838074d2fac94129b5fb2e88622619c76011e57f12c50c560923"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "dcfafb2e1abf197f98f3452c53375aa0f72b9ebef04cb0b7f37d131181551330"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "246aad3351ee67b9e20c9c78a8ecc60e8bcfc7f0fb5ef544b07322af8206e4bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5062c7ecff47f50b55169fb91b19b100237535ce3fff3796f273617b59df58aa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "542f99d9f78e4a9820b6ea2fa1e265d5e261d0d6fdfe98e08af41327d16bdb5e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0d03cde2be335d6c4b096090f9c61b9f2af639fe7e10b9d25ca876bcb2613aed"
    sha256 cellar: :any_skip_relocation, sonoma:         "c58a9a03c8ae224ccac719f8f3e3345eea9848592fcb802751e6eae2176e0e12"
    sha256 cellar: :any_skip_relocation, ventura:        "e57f45a96041ad2e60e4f3203fab14346a85c67d05f87885bbac162a9f805b3c"
    sha256 cellar: :any_skip_relocation, monterey:       "906607cb9db983c3fc6db43774e66a1e33d19ceaacc5814dad554a9cf38364a5"
    sha256 cellar: :any_skip_relocation, big_sur:        "59cb045e4e21e2e205b0b51bbbaa189838c212741fdbbed061596e924286ec97"
    sha256 cellar: :any_skip_relocation, catalina:       "50cafca29cd1fb950794b9f240da2813dbd7dc682dfdb8c75c091cdc9666737e"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "c337e9b4f70cc61fda6ad272b9760f456e3a32c36d7d9842e2c3bc44b06134eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4c91a552e56c4f2e78422c8a4721d7ffbb54bb0bdb326e983f9989c5c9500ce"
  end

  def install
    inreplace "Makefile", "all: nbimg win32", "all: nbimg"
    system "make", "prefix=#{prefix}",
                   "bindir=#{bin}",
                   "docdir=#{doc}",
                   "mandir=#{man}",
                   "install"
  end

  test do
    resource "homebrew-test-bmp" do
      url "https://gist.githubusercontent.com/staticfloat/8253400/raw/41aa4aca5f1aa0a82c85c126967677f830fe98ee/tiny.bmp"
      sha256 "08556be354e0766eb4a1fd216c26989ad652902040676379e1d0f0b14c12f2e2"
    end

    resource("homebrew-test-bmp").stage testpath
    system bin/"nbimg", "-Ftiny.bmp"
    assert_path_exists testpath/"tiny.bmp.nb"
  end
end
