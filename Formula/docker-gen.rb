class DockerGen < Formula
  desc "Generate files from docker container metadata"
  homepage "https://github.com/nginx-proxy/docker-gen"
  url "https://github.com/nginx-proxy/docker-gen/archive/0.10.0.tar.gz"
  sha256 "3326b42377b611f403bd31dbb625c55e666cb2e8202a76a6e13a2cc546a39446"
  license "MIT"
  head "https://github.com/nginx-proxy/docker-gen.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b1cddad4b19cfa649e91b0095cadf00c6c05477153f3c69c80022bd741e1f8b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d62926377aa2e6debe319dd30b771f9b52af29ed60fe26025f047bb56e624f20"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "97620ddb7b21d103c786e48e3672e1d860af31fcf8348eeaf98a232a44ec767b"
    sha256 cellar: :any_skip_relocation, ventura:        "4c99a8b9612cc538d4b608bb4dbf6d899c1153ee1131a0b3dfdd52cbcb5b18df"
    sha256 cellar: :any_skip_relocation, monterey:       "1b35b899981444829c1f5428e44eff955a8dc65e1177cc7a5332ce3e3550a675"
    sha256 cellar: :any_skip_relocation, big_sur:        "24fa854a9bf89e14ae58946117840044b664f89d52d492f9e766957c7c3e4518"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6239ac629bc1c3e0b24fdc5a22a87173ea4586ad673730ff39c45707e7ea3bd"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.buildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/docker-gen"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/docker-gen --version")
  end
end
