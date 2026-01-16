class Fricas < Formula
  desc "Advanced computer algebra system"
  homepage "https://fricas.github.io"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/fricas/fricas.git", branch: "master"

  stable do
    url "https://github.com/fricas/fricas/archive/refs/tags/1.3.12.tar.gz"
    sha256 "f201cf62e3c971e8bafbc64349210fbdc8887fd1af07f09bdcb0190ed5880a90"

    # Build fricas as a SBCL core file instead of standalone executable.
    # Avoid patchelf issue on Linux and codesign issue on macOS.
    patch do
      url "https://github.com/fricas/fricas/commit/4d7624b86b1f4bfff799724f878cf3933459507d.patch?full_index=1"
      sha256 "dbfbd13da8ca3eabe73c58b716dde91e8a81975ce9cafc626bd96ae6ab893409"
    end
    patch do
      url "https://github.com/fricas/fricas/commit/03e4e83288ea46bb97f23c05816a9521f14734b7.patch?full_index=1"
      sha256 "3b9dca32f6e7502fea08fb1a139d2929c89fe7f908ef73879456cbdd1f4f0421"
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e9a297b78558b91737c3c3d03d12437405551fac907e9652eab4d415ac6fa961"
    sha256 cellar: :any,                 arm64_sequoia: "36c8ae50dbb6ebca8fcb7bc76692470997f05428af2969ae2e5ed1aeb4a52adc"
    sha256 cellar: :any,                 arm64_sonoma:  "89c1c4e80411f7d0eafc487926f589ca3a0d874f88dad2133fa5676af9542a1e"
    sha256 cellar: :any,                 sonoma:        "43e36b8ff4477029525d7051560309056e8f101873306dacdb9ac8c4ce26475e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57900b6decf4be69df0dfb499be874dfae4b250465f1d0e59dc25468738884af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f303fc5d5793d86993b3c8355a436b821a5791ec5be5476202c3faae5959fbd"
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
