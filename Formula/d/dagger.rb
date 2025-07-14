class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger/archive/refs/tags/v0.18.12.tar.gz"
  sha256 "3c4a3fddc05b4f2109110a1515d3f6aa0909e5d28a9c3edee9010d0c788e8d16"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44963f9b6e3a8d3c226028370df7278d1771b10b25954b70da921b8386aa4148"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44963f9b6e3a8d3c226028370df7278d1771b10b25954b70da921b8386aa4148"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "44963f9b6e3a8d3c226028370df7278d1771b10b25954b70da921b8386aa4148"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8f8e00a5056e43ac51b565c83ca86d168a517b1daefb5d57c748bbf0930ea63"
    sha256 cellar: :any_skip_relocation, ventura:       "d8f8e00a5056e43ac51b565c83ca86d168a517b1daefb5d57c748bbf0930ea63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3504997f8b9ed0fc31fa21fa4697573a121c1fbafd35258f0e12c0ee98f0818"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    ldflags = %W[
      -s -w
      -X github.com/dagger/dagger/engine.Version=v#{version}
      -X github.com/dagger/dagger/engine.Tag=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/dagger"

    generate_completions_from_executable(bin/"dagger", "completion")
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    assert_match "dagger v#{version}", shell_output("#{bin}/dagger version")

    output = shell_output("#{bin}/dagger query brewtest 2>&1", 1)
    assert_match "Cannot connect to the Docker daemon", output
  end
end
