class Mldonkey < Formula
  desc "OCaml/GTK client for the eDonkey P2P network"
  homepage "https://mldonkey.sourceforge.io"
  url "https://github.com/ygrek/mldonkey/releases/download/release-3-1-6/mldonkey-3.1.6.tar.bz2"
  sha256 "1b36b57c05a83c2e363c085bf8e80630884c6c92ecdeffc1ad5e1c39a98e043d"
  revision 2
  head "https://github.com/ygrek/mldonkey.git", :branch => "next"

  bottle do
    rebuild 1
    sha256 "4b69f4572789c1e8ea5ddb273b0dc816224b192ca6e486353224ce7878c10c1c" => :sierra
    sha256 "caead710b3c7d058f09ca482d296d50b58b3e1419e5a7330f9227970ae34b58b" => :el_capitan
    sha256 "174930623fa07bdfa5ac8e1281d48f01e90e8bdc2acb54e1fd768d7356aaec9e" => :yosemite
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
