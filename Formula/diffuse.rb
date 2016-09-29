class Diffuse < Formula
  desc "Graphical tool for merging and comparing text files"
  homepage "http://diffuse.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/diffuse/diffuse/0.4.8/diffuse-0.4.8.tar.bz2"
  sha256 "c1d3b79bba9352fcb9aa4003537d3fece248fb824781c5e21f3fcccafd42df2b"

  bottle do
    cellar :any_skip_relocation
    sha256 "ca2764034fc37d643f2efadfc4fc307479263988945d8d65019fad240f4a5ea6" => :sierra
    sha256 "d2f0ed47838f888753d7fe4a7c93a9557d8b8826548c53b6098789ab22211562" => :el_capitan
    sha256 "5e7703ec672b8f5636463a5cb0e3a79bb635a485d6657e1921d3cae63a140125" => :yosemite
    sha256 "e2b2b9bcb2c60f014c56e8c924b020a9568b9ebbb9b97c81e6be02be89933c69" => :mavericks
  end

  depends_on "pygtk"

  def install
    system "python", "./install.py",
                     "--sysconfdir=#{etc}",
                     "--examplesdir=#{share}",
                     "--prefix=#{prefix}"
  end

  test do
    system "#{bin}/diffuse", "--help"
  end
end
