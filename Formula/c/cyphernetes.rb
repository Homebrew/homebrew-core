class Cyphernetes < Formula
  desc "Kubernetes Query Language"
  homepage "https://cyphernet.es"
  url "https://github.com/AvitalTamir/cyphernetes/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "cb4d83c9db0aaaaef8caae502c0797148cc71b8a4a6223f9ae2712cd4ce97d7f"
  license "Apache-2.0"
  head "https://github.com/AvitalTamir/cyphernetes.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64eca76d22d73e2ffd5b3d3658248683b77c20c8d9be0f2addb335444406c006"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "64eca76d22d73e2ffd5b3d3658248683b77c20c8d9be0f2addb335444406c006"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "64eca76d22d73e2ffd5b3d3658248683b77c20c8d9be0f2addb335444406c006"
    sha256 cellar: :any_skip_relocation, sonoma:        "401165017fb820a352671efd89e263894ab0364e52cf9ac09928619b5020372e"
    sha256 cellar: :any_skip_relocation, ventura:       "401165017fb820a352671efd89e263894ab0364e52cf9ac09928619b5020372e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a2da0e9d3966580d50c10c9954a060469294dbaff7f2d49f27d1fb33998efd6"
  end

  depends_on "go" => :build

  def install
    system "make", "operator-manifests"
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/cyphernetes"

    generate_completions_from_executable(bin/"cyphernetes", "completion")
  end

  test do
    output = shell_output("#{bin}/cyphernetes query 'MATCH (d:Deployment)->(s:Service) RETURN d' 2>&1", 1)
    assert_match("Error creating provider:  failed to create config: invalid configuration", output)

    assert_match version.to_s, shell_output("#{bin}/cyphernetes version")
  end
end
