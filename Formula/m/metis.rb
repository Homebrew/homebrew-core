class Metis < Formula
  desc "Programs that partition graphs and order matrices"
  homepage "https://karypis.github.io/glaros/software/metis/overview.html"
  url "https://karypis.github.io/glaros/files/sw/metis/metis-5.1.0.tar.gz"
  mirror "https://ftp.mcs.anl.gov/pub/pdetools/spack-pkgs/metis-5.1.0.tar.gz"
  sha256 "76faebe03f6c963127dbb73c13eab58c9a3faeae48779f049066a21c087c5db2"
  license "Apache-2.0"

  livecheck do
    url :homepage
    regex(%r{href=.*?/metis[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "dbb37a32bc124a76fd9496b0e95f49b1bb48b1dfe72dc398991569156193d07e"
    sha256 cellar: :any,                 arm64_sequoia:  "60ef633238eb902353465719c36fb64c5a325f823a203c1079c3e0358f72fd79"
    sha256 cellar: :any,                 arm64_sonoma:   "d1b85dedb77b4a578a06ba705e759768f3ad832fb744669e06f97bd233bf82ff"
    sha256 cellar: :any,                 arm64_ventura:  "5bea2beeae9e3394cc675df14dc30e078b6ed575f0bad4c05717ee3f75ed4aee"
    sha256 cellar: :any,                 arm64_monterey: "9924dff9c2995788c3e69a1affb9931035b66af7b2fef57fedbb0b2f14071d9f"
    sha256 cellar: :any,                 arm64_big_sur:  "ea93856908a2c1c60023dd2f849339d479b20ab4ae6d51623f9496f64993ca20"
    sha256 cellar: :any,                 sonoma:         "daaf2366f0870fd9cf13446d1dee1a8a9bfebb742748fee2911cfabe1e53407f"
    sha256 cellar: :any,                 ventura:        "19688362378a05d974db2c6552376ef5b952b5c2b5bc27dde34c23ab27f5736b"
    sha256 cellar: :any,                 monterey:       "53ceaf6862363106724577ff6568285ba22ff97ef8849eeb7ec0a8e589ef7ff2"
    sha256 cellar: :any,                 big_sur:        "bca0197271b673ba235c37334494b47250c9732e9a0164d8ee79948fc3cd4308"
    sha256 cellar: :any,                 catalina:       "b410b124973bf31beb58806d4050b8dda1fb3dca679fc3443514025200fd4a37"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "8703574aca9ad47530cd56fdb31ec1e24b16643390a0cda290e19271a9a47690"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8daac6acbeaad9583ff26d72a8ad440ac41efb8656973213902bdfe66cd61e6"
  end

  depends_on "cmake" => :build

  def install
    # Fix build with CMake 4.0+.
    inreplace "CMakeLists.txt",
              "cmake_minimum_required(VERSION 2.8)",
              "cmake_minimum_required(VERSION 3.10)"
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath}"

    system "make", "config", "prefix=#{prefix}", "shared=1"
    system "make", "install"

    pkgshare.install "graphs"
  end

  test do
    ["4elt", "copter2", "mdual"].each do |g|
      cp pkgshare/"graphs/#{g}.graph", testpath
      system bin/"graphchk", "#{g}.graph"
      system bin/"gpmetis", "#{g}.graph", "2"
      system bin/"ndmetis", "#{g}.graph"
    end
    cp [pkgshare/"graphs/test.mgraph", pkgshare/"graphs/metis.mesh"], testpath
    system bin/"gpmetis", "test.mgraph", "2"
    system bin/"mpmetis", "metis.mesh", "2"
  end
end
