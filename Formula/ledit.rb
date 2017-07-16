class Ledit < Formula
  desc "Line editor for interactive commands"
  homepage "http://pauillac.inria.fr/~ddr/ledit/"
  url "http://pauillac.inria.fr/~ddr/ledit/distrib/src/ledit-2.03.tgz"
  sha256 "ce08a8568c964009ccb0cbba45ae78b9a96c823f42a4fd61431a5b0c2c7a19ce"
  revision 2

  bottle do
    cellar :any_skip_relocation
    sha256 "19a3c01773ed5cfa28d3b3cf144d3c21f26f5e716bfa0b446115c11fad4ab3ba" => :sierra
    sha256 "d863f55875afb7efd6ccce5ace4c5722c1c62fe50c474231a3f406630aeb5cad" => :el_capitan
    sha256 "5ba23ccff679120de626f8287bae7bfd6d5d0ffc2b97b1e0f559d62f1cf05c8e" => :yosemite
  end

  depends_on "ocaml"
  depends_on "camlp5"

  def install
    # like camlp5, this build fails if the jobs are parallelized
    ENV.deparallelize
    args = %W[BINDIR=#{bin} LIBDIR=#{lib} MANDIR=#{man}]
    system "make", *args
    system "make", "install", *args
  end

  test do
    history = testpath/"history"
    pipe_output("#{bin}/ledit -x -h #{history} bash", "exit\n", 0)
    assert history.exist?
    assert_equal "exit\n", history.read
  end
end
