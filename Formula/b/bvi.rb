class Bvi < Formula
  desc "Vi-like binary file (hex) editor"
  homepage "https://bvi.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/bvi/bvi/1.5.0/bvi-1.5.0.src.tar.gz"
  sha256 "6540716a1a3b2b9711635108da14b26baea488881d4a682121c0bddbba6b74cb"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "e18948359f9988ce1cfc894be133b8c70540c611b93ef222001470fad650608a"
    sha256 arm64_sequoia: "9968f17b11435b15e8f5182ec678fc9006969d4932119006a3be55372c176d8a"
    sha256 arm64_sonoma:  "aa61abd709f9c346f50aa2284e38f2fdecca90e600dcf9f34a76505d0d256d83"
    sha256 arm64_ventura: "dedbee4190affcaa87fde67b7027a64655245a4192eee436273029bbd1c1ce6b"
    sha256 sonoma:        "a5ca83f528845edfd49363d7900d3a2961d3d4e36dc35f4eeb4c842b72f9d223"
    sha256 ventura:       "13a2ff43c275882c8d8658690aab4a51d4b54cde10189c254f4862a6c38db90c"
    sha256 arm64_linux:   "da9dc6e14ca302a2cfcdbd83727273520610eafcf8a3b199d3ea430734424bc3"
    sha256 x86_64_linux:  "613c30ea6216543c1b1d27ed5c57e1cfb6bfabcc81a8d11c8e17a1f851b3bbe6"
  end

  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      out = shell_output("#{bin}/bvi -c q", 1)
      assert_match out, "Input is not from a terminal"
    else
      system bin/"bvi", "-c", "q"
    end
  end
end
