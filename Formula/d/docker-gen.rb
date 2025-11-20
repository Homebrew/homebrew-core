class DockerGen < Formula
  desc "Generate files from docker container metadata"
  homepage "https://github.com/nginx-proxy/docker-gen"
  url "https://github.com/nginx-proxy/docker-gen/archive/refs/tags/0.16.0.tar.gz"
  sha256 "37484452798c719696fd7af607d529479d07a049a678423fb15a8c45f30bf240"
  license "MIT"
  head "https://github.com/nginx-proxy/docker-gen.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d0db9ff20977cfe01cb66396602550bc37dc58ff5d41213fe0d9fd2860c326fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0db9ff20977cfe01cb66396602550bc37dc58ff5d41213fe0d9fd2860c326fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0db9ff20977cfe01cb66396602550bc37dc58ff5d41213fe0d9fd2860c326fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "5924c95a9a2d02b0199cfd81ee8f2ba62596c3276a562ada1703ff639f2288c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69a70f7ed42d3cb3333b8aa756d3797dfc5bb100353f0d0976dd646ae4daa2df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb51cb44310bf06a78c99a51ca2b35b8ef2a2dc3806908e86d1c74f648cdf6d9"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.buildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/docker-gen"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/docker-gen --version")
  end
end
