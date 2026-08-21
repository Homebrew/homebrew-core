class Fricas < Formula
  desc "Advanced computer algebra system"
  homepage "https://fricas.github.io"
  url "https://github.com/fricas/fricas/archive/refs/tags/1.3.13.tar.gz"
  sha256 "7ae03c0f566c4b2bbbd6da1b02965e2a5492b1b8e4f8f2f1d1329c72d44e42a2"
  license "BSD-3-Clause"
  revision 6
  head "https://github.com/fricas/fricas.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e41debe2491d7cc81c11222aaa277ce9a78ddd3600d87e18e3b68d99ab3fdb1e"
    sha256 cellar: :any, arm64_sequoia: "7476f4bec71af84c48c812ebf4e07626c6920ab6b820ba85150292f1efd83c8f"
    sha256 cellar: :any, arm64_sonoma:  "15d92b09ea19fc1fe29e0a8763ec4b3b625703bd330969e33bdb21be1327d783"
    sha256 cellar: :any, sonoma:        "ad8401799a5ba871a25cbf0a1fcda67ddba6802c6642a1c4ab832f04bcd5e16f"
    sha256 cellar: :any, arm64_linux:   "b4969788e7b6694b77c588a010cb67f1b0caa3462f4898e619b4fd27527e8706"
    sha256 cellar: :any, x86_64_linux:  "9c52a4a1bf6997af38987c7926fb16b25c0ebf5be76bac5ce0a3218dbc8645c9"
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
