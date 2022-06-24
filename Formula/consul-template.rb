class ConsulTemplate < Formula
  desc "Generic template rendering and notifications with Consul"
  homepage "https://github.com/hashicorp/consul-template"
  url "https://github.com/hashicorp/consul-template.git",
      tag:      "v0.29.1",
      revision: "4525703f9dd1347a38446e137d56de94dcd06ee7"
  license "MPL-2.0"
  head "https://github.com/hashicorp/consul-template.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e752401b98adb034e14425fce7ff3306682b2e68a7279c8cb402f5e2a2c36606"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9bdfd03ace532166bfc04c34fd089983f73f4ef009ad8a8b5860f169a012eeb2"
    sha256 cellar: :any_skip_relocation, monterey:       "9757f195051d2537237cc1d76401416ce5e6a41a3b3f9b717a072358d075a3e5"
    sha256 cellar: :any_skip_relocation, big_sur:        "88a96a541571092d687948adb75b868f170023ad2a185d5ee9c6a6c352340398"
    sha256 cellar: :any_skip_relocation, catalina:       "3ce15138a3a5783f9e26b177882a500db26563db8c2d518b32c77c085bf49588"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ffb3f6d8ee479e5257d5c32ec7941d57d7e3feb9cb40eb8b375f75b8924dd2a4"
  end

  depends_on "go" => :build

  def install
    project = "github.com/hashicorp/consul-template"
    ldflags = %W[
      -s -w
      -X #{project}/version.Name=consul-template
      -X #{project}/version.GitCommit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
    prefix.install_metafiles
  end

  test do
    (testpath/"template").write <<~EOS
      {{"homebrew" | toTitle}}
    EOS
    system bin/"consul-template", "-once", "-template", "template:test-result"
    assert_equal "Homebrew", (testpath/"test-result").read.chomp
  end
end
