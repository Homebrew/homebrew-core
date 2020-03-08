class Afsctool < Formula
  desc "Control HFS+ and APFS transparent file compression"
  homepage "https://github.com/RJVB/afsctool"
  url "https://github.com/RJVB/afsctool/archive/1.7.0.tar.gz"
  sha256 "4ae643ae43aca22e96cd6a2a471f5d975a3d08eafa937c1fc8e562691bcbfb1a"
  bottle do
    cellar :any_skip_relocation
    rebuild 3
    sha256 "f418e15be4bafdcb1a85e14c3148c8d4af1b300bd6ed3e4a30eca3725459ac48" => :catalina
    sha256 "15c264a828ed98a42cc5ac68869c16b8306f73effe108e50bb1f731574311c51" => :mojave
    sha256 "72e92414d524b82ec1d8381ad50f55bd330f1109a5e10bca4235300fee557caf" => :high_sierra
    sha256 "96437b04a2974c215979550d3d70b4c8e3f609e76954ca41059c6f246da452ee" => :sierra
  end
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "google-sparsehash"

  def install
    cd buildpath do
      mkpath "afsctool/build"
      cd "afsctool/build" do
        system "cmake", "-Wno-dev", "../.."
        system "make"
        bin.install "afsctool"
      end
    end
  end

  test do
    path = testpath / "foo"
    path.write "some text here."
    system "#{bin}/afsctool", "-c", path
    system "#{bin}/afsctool", "-v", path
  end
end
