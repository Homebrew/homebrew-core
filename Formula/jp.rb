class Jp < Formula
  desc "Dead simple terminal plots from JSON data"
  homepage "https://github.com/sgreben/jp"
  url "https://github.com/sgreben/jp/archive/1.1.12.tar.gz"
  sha256 "8c9cddf8b9d9bfae72be448218ca0e18d24e755d36c915842b12398fefdc7a64"

  bottle do
    cellar :any_skip_relocation
    sha256 "ee325c2512d2a069983175999db20d55c8718fd0f0ea000692e6517ac67b32b9" => :catalina
    sha256 "53127a663b20c7c0ac893d991330ca862a6eaa8f235586019e1b8ac33159bcf3" => :mojave
    sha256 "51045489ba9e8790a83a2a366709bd941d3a9e7c190f6c184bcf308b888496b3" => :high_sierra
    sha256 "b75e4ab3a48e2212babba26a4258645ae55eefa50a9ccac463991b05ce4c08d6" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    build_root = buildpath/"src/github.com/sgreben/jp"
    build_root.install Dir["*"]
    cd build_root do
      system "make", "binaries/osx_x86_64/jp"
      bin.install "binaries/osx_x86_64/jp"
    end
  end

  test do
    pipe_output("#{bin}/jp -input csv -xy '[*][0,1]'", "0,0\n1,1\n", 0)
  end
end
