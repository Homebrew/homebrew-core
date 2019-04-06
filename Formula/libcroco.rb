class Libcroco < Formula
  desc "CSS parsing and manipulation toolkit for GNOME"
  homepage "http://www.linuxfromscratch.org/blfs/view/svn/general/libcroco.html"
  url "https://download.gnome.org/sources/libcroco/0.6/libcroco-0.6.13.tar.xz"
  sha256 "767ec234ae7aa684695b3a735548224888132e063f92db585759b422570621d4"

  bottle do
    cellar :any
    sha256 "c4b14566816d0d88fda9e44ea88d10ea673c988bc996e542f8b533066715d7ce" => :mojave
    sha256 "a49d23242587ef0d0717158e7a2212f64cdced70daf1494aa6df339638cb7329" => :high_sierra
    sha256 "03c4e294957af16c882aa6b94cbf3b7f5f8e9da8f8a586a9a0732656b1af0d34" => :sierra
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-Bsymbolic"
    system "make", "install"
  end

  test do
    (testpath/"test.css").write ".brew-pr { color: green }"
    assert_equal ".brew-pr {\n  color : green\n}",
      shell_output("#{bin}/csslint-0.6 test.css").chomp
  end
end
