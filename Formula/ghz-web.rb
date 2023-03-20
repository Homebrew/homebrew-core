class GhzWeb < Formula
  desc "Web interface for ghz"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.114.0.tar.gz"
  sha256 "a2461c048731333e792aab915d0f1da626cbb984dc2bffb6cb66a7c22f198363"
  license "Apache-2.0"

  livecheck do
    formula "ghz"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af986fefb03293d7b56ca2d14a0e83695bf14a7ce38c15c3225dc59f163ba238"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be7a0a2745b6f144b5022cf25349c19bc70c2f59c38ddc2e96b353b9b31f5d75"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d867637f5dbdb1d9b6606cb1f76cbaca94189fedcaacdac93d0dd02da0bd1bf2"
    sha256 cellar: :any_skip_relocation, ventura:        "64972e3c6be2462539d9ed01e152e45466309148aa2d39cfa3c4747f895a4e09"
    sha256 cellar: :any_skip_relocation, monterey:       "d1e0f70452550dffb607ebbbe59fd4ea7b6c64de1272a8835c37a2d2946747aa"
    sha256 cellar: :any_skip_relocation, big_sur:        "10191fd6fda60bc396e2dd9c7abfa898a01750efbbac565ebf179d3cffae9551"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25addd41e360fbdbf2ee5296621b505ec89b103afc98bbdd0645602d399199ba"
  end

  depends_on "go" => :build
  depends_on xcode: :build

  def install
    ENV["CGO_ENABLED"] = "1"
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "cmd/ghz-web/main.go"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ghz-web -v 2>&1")
    port = free_port
    ENV["GHZ_SERVER_PORT"] = port.to_s
    fork do
      exec "#{bin}/ghz-web"
    end
    sleep 1
    cmd = "curl -sIm3 -XGET http://localhost:#{port}/"
    assert_match "200 OK", shell_output(cmd)
  end
end
