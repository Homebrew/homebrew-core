class Pacvim < Formula
  desc "Learn vim commands via a game"
  homepage "https://github.com/jmoon018/PacVim"
  url "https://github.com/jmoon018/PacVim/archive/v1.1.1.tar.gz"
  sha256 "c869c5450fbafdfe8ba8a8a9bba3718775926f276f0552052dcfa090d21acb28"
  head "https://github.com/jmoon018/PacVim.git"

  bottle do
    sha256 "adb164c1decfda7414827e3c7932f6b49c055ef093618dfc6f9381f118df2e73" => :mojave
    sha256 "ce8a3d33ea044109ca9d32e486a8373e732dfea439bc68169335a260c5947659" => :high_sierra
    sha256 "7cdbfca5fe0209e68f3f79e7949a6e60c96435c3a8da68e59036142d54a706dc" => :sierra
    sha256 "91b0806e76c36ddb814f6a54cac2722b21784f9be1604aee45e7091099172f8a" => :el_capitan
    sha256 "36b138084ac97f4eb28bc6b7068e19dc28cc478459fc59de12e8e849820ac65d" => :yosemite
    sha256 "1f5e908420b40f2af868727b7065a51ebc39525c241b983f7f9b9449b95fdc1c" => :mavericks
    sha256 "13f43d00b08183febdc7afcba0553cd512dd9ae23a7fd770b09e3eedb4f8ea37" => :mountain_lion
  end

  needs :cxx11

  def install
    ENV.cxx11
    system "make", "install", "PREFIX=#{prefix}"
  end
end
