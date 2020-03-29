class Ocamlbuild < Formula
  desc "Generic build tool for OCaml"
  homepage "https://github.com/ocaml/ocamlbuild"
  url "https://github.com/ocaml/ocamlbuild/archive/0.14.0.tar.gz"
  sha256 "87b29ce96958096c0a1a8eeafeb6268077b2d11e1bf2b3de0f5ebc9cf8d42e78"
  revision 2
  head "https://github.com/ocaml/ocamlbuild.git"

  bottle do
    sha256 "8f6fc7e7413b24faa041b7651349a3128f9eadefae5c9aa0c50f0d1a56e010f6" => :catalina
    sha256 "04fed811edb4dd3903f742ec6678643f9959e85c4fcb763972c8779dec059515" => :mojave
    sha256 "e4cd0274f9657874e29add30545055af4ea8697d426ed95f799ddce63aef5cfe" => :high_sierra
  end

  depends_on "ocaml"

  def install
    system "make", "configure", "OCAMLBUILD_BINDIR=#{bin}", "OCAMLBUILD_LIBDIR=#{lib}", "OCAMLBUILD_MANDIR=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ocamlbuild --version")
  end
end
