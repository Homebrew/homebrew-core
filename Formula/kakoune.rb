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
    sha256 "6d8ec70c697c45eddc871ded6f6b3a2dd2414e71f68927ee7ecd7b3fc7b61d65" => :catalina
    sha256 "da609221aa96abae411b14308db149787c057f3500c52a84cc1e110e07628386" => :mojave
    sha256 "a7019f4cb116eeaa0a6f20f497374722947da86144bf2aa22afbadfc384a409a" => :high_sierra
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
