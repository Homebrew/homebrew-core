class PowermanDockerize < Formula
  desc "Utility to simplify running applications in docker containers"
  homepage "https://github.com/powerman/dockerize"
  url "https://github.com/powerman/dockerize/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "192c142ab25893c7a1e8a135280d8e72f05f12b56c1e2b5d932946707ec68c6b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f3b2985c7df26cc45ea461d2ba73eebc2d74e3c2a3be2ca06515c96ddb24355d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "295b42056ef7c3671cceb6d3dcf291291da7e888b53cfef13a31a740f98dc41e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1b4c5641593af5f64015d54b1d583b36e29cb277f3caf1227f8130a6e853ca27"
    sha256 cellar: :any_skip_relocation, ventura:        "f0e93cc3cdaa1b1a9625a0a835510f7840944f357ea5140b81abd66cefc29a01"
    sha256 cellar: :any_skip_relocation, monterey:       "39520ba40547427c7fddc96b6d11077ba7d628e2c8f7a01408ff64afffb9efeb"
    sha256 cellar: :any_skip_relocation, big_sur:        "316718edcda00d3f8ba267646865374853f13732e4657b880aebe5e15dd8cf7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "618f0667675365d041d46e9396a26841a3425f090c687be3d23d4cbab3a1b9a2"
  end

  depends_on "go" => :build
  conflicts_with "dockerize", because: "powerman-dockerize and dockerize install conflicting executables"

  def install
    system "go", "build", *std_go_args(output: bin/"dockerize", ldflags: "-s -w -X main.ver=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockerize --version")
    system "#{bin}/dockerize", "-wait", "https://www.google.com/", "-wait-retry-interval=1s", "-timeout", "5s"
  end
end
