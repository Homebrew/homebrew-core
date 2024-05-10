class DockerGen < Formula
  desc "Generate files from docker container metadata"
  homepage "https://github.com/nginx-proxy/docker-gen"
  url "https://github.com/nginx-proxy/docker-gen/archive/refs/tags/0.13.0.tar.gz"
  sha256 "f6b2852371d02faa2e8b6f3e7c71e0c536ab994eac19f669515f2502220cd46d"
  license "MIT"
  head "https://github.com/nginx-proxy/docker-gen.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "069003c17186aede9d553148c24361907fd5a7148f667198d8604aa5bb1a88b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "20016736a8a6e4f3bcff5c979942aca142b853f6d34ae60fd29846a1f69ac80a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "50cb67cdfaf24976eed42c8f2a0edd8c027b383d0e29ba37fb03d8001047a114"
    sha256 cellar: :any_skip_relocation, sonoma:         "9a7c79f1e4da30fa49e24f26a76c28ec102e0df57005a3351e6c20786b888504"
    sha256 cellar: :any_skip_relocation, ventura:        "d8b4007381c7d2480a6c3a662ce4309d95201cc1e2bac76142c3f1a3128f8d56"
    sha256 cellar: :any_skip_relocation, monterey:       "ebc595cf800c0da7cb6c25bad4e1bd760546c253e0d45a3ba46bc82e776d53ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "159f026ed2c10a85eae1a50822a94eada08e3e11297a15f61b9780c482cca03b"
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
