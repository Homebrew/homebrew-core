class Mldonkey < Formula
  desc "OCaml/GTK client for the eDonkey P2P network"
  homepage "https://mldonkey.sourceforge.io"
  url "https://github.com/ygrek/mldonkey/releases/download/release-3-1-6/mldonkey-3.1.6.tar.bz2"
  sha256 "1b36b57c05a83c2e363c085bf8e80630884c6c92ecdeffc1ad5e1c39a98e043d"
  revision 2
  head "https://github.com/ygrek/mldonkey.git", :branch => "next"

  bottle do
    sha256 "3ce7cea1dcb24867f474488fb7b85fd8c0387fefaf1919c67e9a2ff538a12e39" => :sierra
    sha256 "a5b13542b152b3421029a6fe2d66d7c9e25b31647ed7b9cb16644866dbeffaa8" => :el_capitan
    sha256 "89af4b702b61cfe0fed14df0d0550a8005ef8456ab403874a8ea3f5330465f53" => :yosemite
  end

  depends_on "camlp4" => :build
  depends_on "ocaml" => :build
  depends_on "pkg-config" => :build
  depends_on "gd"
  depends_on "libpng"

  def install
    ENV.deparallelize

    # Fix compiler selection
    ENV["OCAMLC"] = "#{HOMEBREW_PREFIX}/bin/ocamlc.opt -cc #{ENV.cc}"

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"mlbt", "--help"
  end
end
