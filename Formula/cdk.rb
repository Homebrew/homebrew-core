class Cdk < Formula
  desc "Curses development kit provides predefined curses widget for apps"
  homepage "https://invisible-island.net/cdk/"
  url "https://invisible-mirror.net/archives/cdk/cdk-5.0-20191231.tgz"
  version "5.0.20191231"
  sha256 "66ed08f35fa82c837177a55fa245287e8b81fc55cb8c6c40d26b041088a72b26"

  bottle do
    cellar :any_skip_relocation
    sha256 "b93ccd51c65c1f964fdee69c23888b35a629c8f24f04b989612130eb2165971c" => :catalina
    sha256 "7590d2bae6079fe756348b41989a9a15ed96506c81ca238517b2c8efaa628a85" => :mojave
    sha256 "a6d01b9dcc46b224a83a4e232a74af179bee8b97db0fe0e2a08692cc5e104336" => :high_sierra
  end

  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}", "--with-ncurses"
    system "make", "install"
  end

  test do
    assert_match lib.to_s, shell_output("#{bin}/cdk5-config --libdir")
  end
end
