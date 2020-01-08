class Fleetctl < Formula
  desc "Distributed init system"
  homepage "https://github.com/coreos/fleet"
  url "https://github.com/coreos/fleet.git",
      :tag      => "v1.0.0",
      :revision => "b8127afc06e3e41089a7fc9c3d7d80c9925f4dab"
  head "https://github.com/coreos/fleet.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2295f49fce4dee23617fec26c19e026ffe3e63c3feb575243a6def944872bb1d" => :catalina
    sha256 "52a1f69af15831025db6aa79b37781e5e225062807ab8d2dc22c3cbf06812c49" => :mojave
    sha256 "01ae897f69a8d74b22c52faeb300380299b2c369eb39c0778eee6fb0602e5309" => :high_sierra
    sha256 "217f22406b9a249f6101b40605b020766547b00bb24e8c005cbdecc099251a80" => :sierra
    sha256 "a51e7c700bb0074445e0a0ccea938592841a49f9c858051f6ec97170e30eccd0" => :el_capitan
    sha256 "09492b0c1dc6af381bb22bec46b51c585db9068cda51f290dc5d2c46d91d6c48" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "./build"
    bin.install "bin/fleetctl"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fleetctl --version")
  end
end
