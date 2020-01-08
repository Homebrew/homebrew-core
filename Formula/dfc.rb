class Dfc < Formula
  desc "Display graphs and colors of file system space/usage"
  homepage "https://projects.gw-computing.net/projects/dfc"
  url "https://projects.gw-computing.net/attachments/download/615/dfc-3.1.1.tar.gz"
  sha256 "962466e77407dd5be715a41ffc50a54fce758a78831546f03a6bb282e8692e54"
  revision 1
  head "https://github.com/Rolinh/dfc.git"

  bottle do
    sha256 "315767ea4838836254830a63f2b10c34faae0ae1f0757c7e6212832da409dc15" => :catalina
    sha256 "1a313424cdf9c4eecd2f9c343f8218da48bec1cf1da3585038e0b0d7742d5247" => :mojave
    sha256 "6729cbd05c951477c251e240afc01f6a1cc4ab04441f653194388a6dcf048d13" => :high_sierra
    sha256 "158a1dc96381a8c13a38aa6682120c5f6985ee2a71bf511eba5b99c32d6ab9e4" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "gettext"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system bin/"dfc", "-T"
    assert_match ",%USED,", shell_output("#{bin}/dfc -e csv")
  end
end
