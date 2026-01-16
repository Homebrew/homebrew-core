class Libtommath < Formula
  desc "C library for number theoretic multiple-precision integers"
  homepage "https://www.libtom.net/LibTomMath/"
  url "https://github.com/libtom/libtommath/releases/download/v1.3.0/ltm-1.3.0.tar.xz"
  sha256 "296272d93435991308eb73607600c034b558807a07e829e751142e65ccfa9d08"
  license "Unlicense"
  head "https://github.com/libtom/libtommath.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "fe707123e6ec8488bae4013ce49404a63b00dc6c1c11b12202e25f53a62ef586"
    sha256 cellar: :any,                 arm64_sequoia:  "180de0f47bf4ce7ec3a513db509d368e148b42e50cf310666bf9c60a78cf778b"
    sha256 cellar: :any,                 arm64_sonoma:   "6b17949dbb9a6a751816e0a39f441a6028b680d15960fe3fdb6686721dac70f3"
    sha256 cellar: :any,                 arm64_ventura:  "ebd34b24dcd868425c2ef5496fdb8d48c852c702cdd0cb77f2d9be123b308163"
    sha256 cellar: :any,                 arm64_monterey: "1e5ac48668cad1a316975799e6467708b5b0e20472ab7dca7bc167e9348e6f89"
    sha256 cellar: :any,                 sonoma:         "cba9f676decfce08aedbc85a2caf32603d93eb186e93b2af1e96fe8bf595b11f"
    sha256 cellar: :any,                 ventura:        "b0e54d27c97e9bad7b9377cb2ba3621c59c5ecd2e231d71b2181316febb008b5"
    sha256 cellar: :any,                 monterey:       "edc215c19f0ee0fd1daa89879a7bc933bf25ddee3b374e4e7b60a8acbaa6f5c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "99f57fc8332837cb3574ed6b078763693050495a233907bcb9c4b63198414e57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7023ad5964a1ccfbbbe850cb0979ffa220a65177efd87e0bb751bcf5a3832ba"
  end

  depends_on "libtool" => :build

  # Fixes mp_set_double being missing on macOS.
  # This is needed by some dependents in homebrew-core.
  # NOTE: This patch has been merged upstream but we take a backport
  # from a fork due to file name differences between 1.2.0 and master.
  # Remove with the next version.
  patch do
    url "https://github.com/MoarVM/libtommath/commit/db0d387b808d557bd408a6a253c5bf3a688ef274.patch?full_index=1"
    sha256 "e5eef1762dd3e92125e36034afa72552d77f066eaa19a0fd03cd4f1a656f9ab0"
  end

  def install
    ENV["PREFIX"] = prefix

    system "make", "-f", "makefile.shared", "install"
    system "make", "test"
    pkgshare.install "test"
  end

  test do
    system pkgshare/"test"
  end
end
