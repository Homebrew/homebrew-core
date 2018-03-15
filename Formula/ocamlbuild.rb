class Ocamlbuild < Formula
  desc "Generic build tool for OCaml"
  homepage "https://github.com/ocaml/ocamlbuild"
  url "https://github.com/ocaml/ocamlbuild/archive/0.12.0.tar.gz"
  sha256 "d9de56aa961f585896844b24c6f7695a9e7ad9d00263fdfe50a17f38b13b9ce1"
  head "https://github.com/ocaml/ocamlbuild.git"

  bottle do
    sha256 "d0d918a35040a90011c699b076bbd8a118c2d9e873e927aac75368f79ba4c19b" => :high_sierra
    sha256 "ef3caa4d73b855fb622459da9196ca63d7c4c00b1e0580a5d32c286c580d1c8b" => :sierra
    sha256 "5dcbb2809634080498691ab99a893483e7e9418abcabb552f18109d414b98dc9" => :el_capitan
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
