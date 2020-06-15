class Ott < Formula
  desc "Tool for writing definitions of programming languages and calculi"
  homepage "https://www.cl.cam.ac.uk/~pes20/ott/"
  url "https://github.com/ott-lang/ott/archive/0.31.tar.gz"
  sha256 "7723378fdec3a322005b7505d20ec1a6ae7756823426317156d2ebafe26fd930"
  head "https://github.com/ott-lang/ott.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "80fab1963ac50aa74b117b52e1678e1cdbfe86b8a5fa10718ee7d6fca45723b2" => :catalina
    sha256 "a46f2577ad1d6e7a8a74083f97996f7e6a841698265c3e85ca2c2ad077da85eb" => :mojave
    sha256 "1a8ec351b4862a9dbfc54741ce2fb75b504c2f5293c4a1aa77504e88b9a3ff4b" => :high_sierra
  end

  depends_on "ocaml" => :build

  def install
    system "make", "world"
    bin.install "bin/ott"
    pkgshare.install "examples"
    (pkgshare/"emacs/site-lisp/ott").install "emacs/ott-mode.el"
  end

  test do
    system "#{bin}/ott", "-i", pkgshare/"examples/peterson_caml.ott",
      "-o", "peterson_caml.tex", "-o", "peterson_caml.v"
  end
end
