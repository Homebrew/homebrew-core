class Grsync < Formula
  desc "GUI for rsync"
  homepage "http://www.opbyte.it/grsync/"
  url "https://downloads.sourceforge.net/project/grsync/grsync-1.2.6.tar.gz"
  sha256 "66d5acea5e6767d6ed2082e1c6e250fe809cb1e797cbbee5c8e8a2d28a895619"
  revision 2

  bottle do
    sha256 "f6d12bc8edca619d77c739ce87bf3e236db3887ad68cbc85aa83977fdd42b5cb" => :catalina
    sha256 "8645e9089cb1045704be43d8c7351b26ced5823331bc0ab7bf94eadfa22c50af" => :mojave
    sha256 "a37529e54d8e00d5a2400fc3ae0e5ccf06d4c84d5e36afc38233859f57f76117" => :high_sierra
    sha256 "a186fcf380ae3b1a73223b9591a8ccd9174a3fee91dae8e445da2dae98d6da71" => :sierra
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gtk+"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-unity",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    # running the executable always produces the GUI, which is undesirable for the test
    # so we'll just check if the executable exists
    assert_predicate bin/"grsync", :exist?
  end
end
