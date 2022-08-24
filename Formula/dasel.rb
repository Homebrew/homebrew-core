class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://github.com/TomWright/dasel/archive/v1.26.1.tar.gz"
  sha256 "44c90753cf4c1b6e7fb82074c6701fd4b47dc6dc26fe4e5504dcccb4d273b946"
  license "MIT"
  head "https://github.com/TomWright/dasel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a482d09275b2df28547276c103a6ed7d2e9e63610933871820c3875a7898ead"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "17377682ed791cca2a1e8cec5292ad37f23c7ee27bfb38406e00159a59c6db49"
    sha256 cellar: :any_skip_relocation, monterey:       "6b28f58bf5f8752de30b17663766b9f38be7ef146f798e24c93487298315774e"
    sha256 cellar: :any_skip_relocation, big_sur:        "81243aaabb436720251235a04dbb978a09e4df8f57e9d25cd9fb530975eef478"
    sha256 cellar: :any_skip_relocation, catalina:       "02c90dbaf04ba46a9f7391020ab357a1e8b5cfa4fd31565e74659d1e4a0d2abd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7f02ca2ab4f8d6fd41b587a04fe0e101e8bedfe9d1e226394d3b4ca978c5869"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X 'github.com/tomwright/dasel/internal.Version=#{version}'"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/dasel"
  end

  test do
    json = "[{\"name\": \"Tom\"}, {\"name\": \"Jim\"}]"
    assert_equal "Tom\nJim", pipe_output("#{bin}/dasel --plain -p json -m '.[*].name'", json).chomp
  end
end
