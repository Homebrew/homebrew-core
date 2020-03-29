class Dialog < Formula
  desc "Display user-friendly message boxes from shell scripts"
  homepage "https://invisible-island.net/dialog/"
  url "https://invisible-mirror.net/archives/dialog/dialog-1.3-20200327.tgz"
  sha256 "466163e8b97c2b7709d00389199add3156bd813f60ccb0335d0a30f2d4a17f99"

  bottle do
    cellar :any_skip_relocation
    sha256 "1b84e68cf11a65f5dd43728d9d033cc9c17f8c048f9f3a77d11d597bb9a6e665" => :catalina
    sha256 "b1d0a994bc49f8ad224e7b1da1373eaa4080824e3e48887335630a4d4dcc726d" => :mojave
    sha256 "d056b71ba4f33ddb8556e946a2fa076ce31b126b8fd7c337f85a8d978c3bb891" => :high_sierra
  end

  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install-full"
  end

  test do
    system "#{bin}/dialog", "--version"
  end
end
