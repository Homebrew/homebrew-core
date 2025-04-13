class Fricas < Formula
  desc "Advanced computer algebra system"
  homepage "https://fricas.github.io"
  url "https://github.com/fricas/fricas/archive/refs/tags/1.3.11.tar.gz"
  sha256 "ce74ad30b2b25433ec0307f48a0cf36e894efdf9c030b7ef7665511f5e6bf7d9"
  license "BSD-3-Clause"
  head "https://github.com/fricas/fricas.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f979124c221aacc487700749338a4be2926cf8e5e41108e9f9c0a55a35d05e7e"
    sha256 cellar: :any,                 arm64_sonoma:  "8989cfeb1e1d63f6489e402ad19fd8433d1b3d206535e9b08af6d16e2c26c6d7"
    sha256 cellar: :any,                 arm64_ventura: "6c37fc5e9a30a29f94aba6999246cdc4428242afbb250836aeaf7e139d359f79"
    sha256 cellar: :any,                 sonoma:        "8ead560ceff9155edf01af8e4d7bdebd803df863848d94aa423431ce6633f58e"
    sha256 cellar: :any,                 ventura:       "eafaa5ea9b679d04b2d77f6c98c2348a1cbc43abd74a70b5bed283524881070a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78aa1002ed22279cdc6aef277ab708d411fcd3c113a516a63f7a62967f324ea4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3704109df28d50e400c8a0e58e23b6d3e7b9eff93adfc2c543bf8c089de170a1"
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
      "--with-lisp=sbcl --dynamic-space-size 4096",
      "--enable-gmp",
    ]

    mkdir "build" do
      system "../configure", *std_configure_args, *args
      system "make"
      system "make", "install"
    end
  end

  test do
    # Fails in Linux CI with "Can't find sbcl.core"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match %r{ \(/ \(pi\) 2\)\n},
      pipe_output(bin/"fricas -nosman", "integrate(sqrt(1-x^2),x=-1..1)::InputForm")
  end
end
