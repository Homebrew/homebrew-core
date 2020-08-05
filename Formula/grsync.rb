class Grsync < Formula
  desc "GUI for rsync"
  homepage "https://www.opbyte.it/grsync/"
  url "https://downloads.sourceforge.net/project/grsync/grsync-1.2.8.tar.gz"
  sha256 "94ea5faca67e3df467b5283377af3cb32b2b47631b6a32d38bc7b371209306b1"

  bottle do
    sha256 "07f40176b0bfb08d3b461fceb2d4e18f249354ef60a57dd550c11c31d26fee6a" => :catalina
    sha256 "b0bf1fe191950905e46c81953e93a72c6c6c185c146b1a79d09e388348e1c5f1" => :mojave
    sha256 "741b7306a6373fc2d86a416a2def2a06c1fd25ab6b30585755faa8326c497c2b" => :high_sierra
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
