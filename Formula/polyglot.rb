class Polyglot < Formula
  desc "Protocol adapter to run UCI engines under XBoard"
  homepage "https://chessprogramming.wikispaces.com/PolyGlot"
  url "http://hgm.nubati.net/releases/polyglot-2.0.4.tar.gz"
  sha256 "c11647d1e1cb4ad5aca3d80ef425b16b499aaa453458054c3aa6bec9cac65fc1"
  head "http://hgm.nubati.net/git/polyglot.git", :branch => "learn"

  bottle do
    cellar :any_skip_relocation
    sha256 "e8fec97a8ac86a2e0a8d73ef7d2867912001cf9c838f2b2943b910f38db88845" => :sierra
    sha256 "fab4e7a336016feb657852395b589bd8aa35b7f8d07147ee3147600ff57de609" => :el_capitan
    sha256 "f3aca0dff8bec92b56d215dae77738863e0216227c40f1bf148eb78b807cbf6f" => :yosemite
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match /^PolyGlot \d\.\d\.[0-9a-z]+ by Fabien Letouzey/, shell_output("#{bin}/polyglot --help")
  end
end
