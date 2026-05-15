class Fricas < Formula
  desc "Advanced computer algebra system"
  homepage "https://fricas.github.io"
  url "https://github.com/fricas/fricas/archive/refs/tags/1.3.13.tar.gz"
  sha256 "7ae03c0f566c4b2bbbd6da1b02965e2a5492b1b8e4f8f2f1d1329c72d44e42a2"
  license "BSD-3-Clause"
  revision 3
  head "https://github.com/fricas/fricas.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "53d8672901ac00c6333f1620c4905c92c9278f4c4ce2969a7f5db031eb06363f"
    sha256 cellar: :any,                 arm64_sequoia: "f700f1e750acde4f24b5c0e5beae756e7a01404dc64b097507280b8f891e5e34"
    sha256 cellar: :any,                 arm64_sonoma:  "ae8c6b033badb886d78df2c5b965baf185bfb5b05a4318ceed639a6a068c07fe"
    sha256 cellar: :any,                 sonoma:        "8d4c7867cc9b020443356de4fa79ca4143c23adc06281a65a8f0a771e410ba22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6083895532bc3694710227554e23e6b62d8a7bc1372b0b83222d489c22b1c1cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72cdc97e2a8642503959c6d3a5975a341c04e991db0e6c2ff5c9bd465ae808e2"
  end

  depends_on "gmp"
  depends_on "libice"
  depends_on "libsm"
  depends_on "libx11"
  depends_on "libxau"
  depends_on "libxdmcp"
  depends_on "libxpm"
  depends_on "libxt"
  depends_on "sbcl"
  depends_on "zstd"

  def install
    args = [
      "--with-lisp=sbcl",
      "--enable-lisp-core",
      "--enable-gmp",
    ]

    mkdir "build" do
      system "../configure", *std_configure_args, *args
      system "make"
      system "make", "install"
    end
  end

  test do
    assert_match %r{ \(/ \(pi\) 2\)\n},
      pipe_output("#{bin}/fricas -nosman", "integrate(sqrt(1-x^2),x=-1..1)::InputForm")
  end
end
