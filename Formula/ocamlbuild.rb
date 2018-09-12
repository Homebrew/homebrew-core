class Ocamlbuild < Formula
  desc "Generic build tool for OCaml"
  homepage "https://github.com/ocaml/ocamlbuild"
  url "https://github.com/ocaml/ocamlbuild/archive/0.13.0.tar.gz"
  sha256 "63339330d863f83990d005f94143a5472500266051c8c46b7300f0a03e4e7ed3"
  head "https://github.com/ocaml/ocamlbuild.git"

  bottle do
    sha256 "c3a3943bef68a2a94b79657040a7dca32c046c89b3e88e5e2ec665b81f5f98a1" => :mojave
    sha256 "24d99c6d544fc8e70d81943eac977ed529eba69e0c06d4dd9e077db396265e69" => :high_sierra
    sha256 "b524da879e10b505885dd3340f664717671adb686ffd1ebf8348e6b793508506" => :sierra
    sha256 "5494e751e376a9c4d7b64ff6e416828e94cf89848b8cfb6633eb811429e54b68" => :el_capitan
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
