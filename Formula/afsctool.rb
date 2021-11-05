class Afsctool < Formula
  desc "Utility for manipulating HFS+ compressed files"
  homepage "https://github.com/RJVB/afsctool"
  url "https://github.com/RJVB/afsctool/archive/1.7.0.tar.gz"
  sha256 "4ae643ae43aca22e96cd6a2a471f5d975a3d08eafa937c1fc8e562691bcbfb1a"
  license "GPL-3.0"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "01af9a80d59e870a48adcbf1eb0cba0a3dd0a4013df397114c4c0f21f16e3916"
    sha256 cellar: :any_skip_relocation, big_sur:       "e7d401a4f723f58ad588e5b2fb5b19c6d76e7faed0385d0b3eef59d1f933e1ee"
    sha256 cellar: :any_skip_relocation, catalina:      "f418e15be4bafdcb1a85e14c3148c8d4af1b300bd6ed3e4a30eca3725459ac48"
    sha256 cellar: :any_skip_relocation, mojave:        "15c264a828ed98a42cc5ac68869c16b8306f73effe108e50bb1f731574311c51"
    sha256 cellar: :any_skip_relocation, high_sierra:   "72e92414d524b82ec1d8381ad50f55bd330f1109a5e10bca4235300fee557caf"
    sha256 cellar: :any_skip_relocation, sierra:        "96437b04a2974c215979550d3d70b4c8e3f609e76954ca41059c6f246da452ee"
  end

  depends_on "cmake" => :build
  depends_on "google-sparsehash" => :build
  depends_on "pkg-config" => :build
  depends_on :macos

  uses_from_macos "zlib"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    path = testpath/"foo"
    path.write "some text here."
    system "#{bin}/afsctool", "-c", path
    system "#{bin}/afsctool", "-v", path
  end
end
