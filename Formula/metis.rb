class Metis < Formula
  desc "Programs that partition graphs and order matrices"
  homepage "http://glaros.dtc.umn.edu/gkhome/views/metis"
  url "http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/metis-5.1.0.tar.gz"
  sha256 "76faebe03f6c963127dbb73c13eab58c9a3faeae48779f049066a21c087c5db2"
  license "Apache-2.0"

  livecheck do
    url "http://glaros.dtc.umn.edu/gkhome/metis/metis/download"
    regex(%r{href=.*?/metis[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5bea2beeae9e3394cc675df14dc30e078b6ed575f0bad4c05717ee3f75ed4aee"
    sha256 cellar: :any,                 arm64_monterey: "9924dff9c2995788c3e69a1affb9931035b66af7b2fef57fedbb0b2f14071d9f"
    sha256 cellar: :any,                 arm64_big_sur:  "ea93856908a2c1c60023dd2f849339d479b20ab4ae6d51623f9496f64993ca20"
    sha256 cellar: :any,                 ventura:        "19688362378a05d974db2c6552376ef5b952b5c2b5bc27dde34c23ab27f5736b"
    sha256 cellar: :any,                 monterey:       "53ceaf6862363106724577ff6568285ba22ff97ef8849eeb7ec0a8e589ef7ff2"
    sha256 cellar: :any,                 big_sur:        "bca0197271b673ba235c37334494b47250c9732e9a0164d8ee79948fc3cd4308"
    sha256 cellar: :any,                 catalina:       "b410b124973bf31beb58806d4050b8dda1fb3dca679fc3443514025200fd4a37"
    sha256 cellar: :any,                 mojave:         "f3cdcf0cc5af4ddd27a4550d4a73cffcb34058fe34604b09d453610460d24465"
    sha256 cellar: :any,                 high_sierra:    "88b6965d941a87044150238387971c4bb94ed2ffca327affccaf311d666a2b4b"
    sha256 cellar: :any,                 sierra:         "9c8deed80ece8c24e7ebccbce8410557b27afe711d3f59fccb7d781254d0cc34"
    sha256 cellar: :any,                 el_capitan:     "54f75262475744bc6ad3ba66ac801e03c18bbac00a9bcf0ca9d05853f2022498"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8daac6acbeaad9583ff26d72a8ad440ac41efb8656973213902bdfe66cd61e6"
  end

  depends_on "cmake" => :build

  def install
    system "make", "config", "prefix=#{prefix}", "shared=1"
    system "make", "install"

    pkgshare.install "graphs"
  end

  test do
    ["4elt", "copter2", "mdual"].each do |g|
      cp pkgshare/"graphs/#{g}.graph", testpath
      system "#{bin}/graphchk", "#{g}.graph"
      system "#{bin}/gpmetis", "#{g}.graph", "2"
      system "#{bin}/ndmetis", "#{g}.graph"
    end
    cp [pkgshare/"graphs/test.mgraph", pkgshare/"graphs/metis.mesh"], testpath
    system "#{bin}/gpmetis", "test.mgraph", "2"
    system "#{bin}/mpmetis", "metis.mesh", "2"
  end
end
