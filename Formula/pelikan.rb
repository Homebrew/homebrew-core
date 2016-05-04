class Pelikan < Formula
  desc "production-ready cache services"
  homepage "http://pelikan.io"
  url "https://github.com/twitter/pelikan/archive/0.1.1.tar.gz"
  sha256 "24a84bd9be7bb25da507a355b7ed3a35f7cb2a8c9447092f5acc91ff32f98775"
  head "https://github.com/twitter/pelikan.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "469116bf1661a4fc3fed1473bcf9619836226e14a6459d83ed67f5eed1c968ee" => :el_capitan
    sha256 "b7370736251899a21560a4cd3d84d103c0f8ce11afa66a2663104e70f72837ad" => :yosemite
    sha256 "654d1adc30a7585c7fc590006fd14124d8341eb9608ae88eeebb629e20003fd6" => :mavericks
  end

  depends_on "cmake" => :build

  def install
    mkdir "_build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/pelikan_twemcache", "-c"
  end
end
