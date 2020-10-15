class Kakoune < Formula
  desc "Selection-based modal text editor"
  homepage "https://github.com/mawww/kakoune"
  url "https://github.com/mawww/kakoune/releases/download/v2020.09.01/kakoune-2020.09.01.tar.bz2"
  sha256 "861a89c56b5d0ae39628cb706c37a8b55bc289bfbe3c72466ad0e2757ccf0175"
  license "Unlicense"
  head "https://github.com/mawww/kakoune.git"

  livecheck do
    url "https://github.com/mawww/kakoune/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any
    sha256 "19ff009f6f44de0e54fc01736f8e145bc6a866307f18adf5a002c8053b7e2bd9" => :catalina
    sha256 "48b2c91f86c65517c8a83a0a0083bc7c0bf54a4e8fc93b22b5744f7c0ce4fc33" => :mojave
    sha256 "dbee14709bcbe746293b0a80852347cc53cb646c9013b6fc119ee37aab4ab859" => :high_sierra
  end

  depends_on macos: :high_sierra # needs C++17
  depends_on "ncurses"

  def install
    cd "src" do
      system "make", "install", "debug=no", "PREFIX=#{prefix}"
    end
  end

  test do
    system bin/"kak", "-ui", "dummy", "-e", "q"
  end
end
