class Abella < Formula
  desc "Interactive theorem prover based on lambda-tree syntax"
  homepage "http://abella-prover.org/"
  url "https://github.com/abella-prover/abella/archive/v2.0.6.tar.gz"
  sha256 "d1f793b1e34f3adcaf6d28e2c0274bccb281afe89c8e3093c1e64df6ec4b9898"
  head "https://github.com/abella-prover/abella.git"

  depends_on "ocaml-findlib" => :build
  depends_on "ocamlbuild" => :build
  depends_on "ocaml"

  # Necessary in order to compile with Homebrew's packaged ocaml version;
  # upstream cant merge this until its testing infrastructure moves to the new version.
  # See: abella-prover/abella#123
  patch do
    url "https://github.com/abella-prover/abella/commit/101faf5553ba1267c0e4c1dda979372b0c38a676.diff?full_index=1"
    sha256 "2f00562b177f1b131dec794fea769153ce767c6e8fd249c159c2a12a9012061a"
  end

  def install
    system "make", "all"
    bin.install "abella"
    pkgshare.install "examples"
    doc.install "README.md", "CHANGES", "LICENSE"
  end

  test do
    # using the provided "subst" example
    cd pkgshare/"examples/misc" do
      cp %w[subst.sig subst.mod subst.thm], testpath
    end
    system bin/"abella", testpath/"subst.thm", "-c", testpath/"subst.thc", "-o", testpath/"subst.out"
    assert_predicate testpath/"subst.thc", :exist?
    assert_predicate testpath/"subst.out", :exist?
  end
end
