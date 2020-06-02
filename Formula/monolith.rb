class Monolith < Formula
  desc "CLI tool for saving complete web pages as a single HTML file"
  homepage "https://github.com/Y2Z/monolith"
  url "https://github.com/Y2Z/monolith/archive/v2.2.7.tar.gz"
  sha256 "8fa8ea66383f7278f6fcbe1ba75ffc9243b93031a88725135ca3b0eeb38c7df9"

  bottle do
    cellar :any_skip_relocation
    sha256 "710e8874fd941a28c926dea540209a499ece0d273d3678d073932e37dd50c70d" => :catalina
    sha256 "9168948208ea046ab8cadc53f4e1cb0beea48339b9681685de874d5535e3dfcb" => :mojave
    sha256 "2bc54dc84e1d9556f59ffbded2b36ed13ec8acd68447d303ea0595955883463b" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "openssl@1.1"

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    system bin/"monolith", "https://lyrics.github.io/db/p/portishead/dummy/roads"
  end
end
