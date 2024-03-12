class Glasskube < Formula
  desc "Missing Package Manager for Kubernetes"
  homepage "https://glasskube.dev/"
  url "https://github.com/glasskube/glasskube/archive/refs/tags/v0.0.4.tar.gz"
  sha256 "0c7d300b6a3deb22047e3d98548c4abcd87d23fc53042bfdce27a458582711db"
  license "Apache-2.0"
  head "https://github.com/glasskube/glasskube.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5fcd17640c6ad8cbce2c9b1e10c00ea5e20f15bec0a10b3a966b7cbd4dfef249"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf06f74fce99d70c1668419054a2ee4d279775c47f4f832f90258080051ca39d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe1c821dca751000f40f4aaa44cb5d5306108a0ae55fb8f0f1c8bb280e953f56"
    sha256 cellar: :any_skip_relocation, sonoma:         "3e591aa0133a40a66250d00bb58d3ab1eb7aaede91b7d5c6a513764a08b8e7e4"
    sha256 cellar: :any_skip_relocation, ventura:        "4c91255b1ccd0e70e297e9d39b909325152d7f99127fc5c92e69a60ea12975bd"
    sha256 cellar: :any_skip_relocation, monterey:       "ff898756de64f5fa47614858c1700dc5351c891721947bb5f32c1a1d12bd1c6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a86d3fa1e362ebc46c319cea855a1ea012e900db4173599c729c4ecc5447b5c8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/glasskube/glasskube/internal/config.Version=#{version}
      -X github.com/glasskube/glasskube/internal/config.Commit=#{tap.user}
      -X github.com/glasskube/glasskube/internal/config.Date=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/glasskube"

    generate_completions_from_executable(bin/"glasskube", "completion")
  end

  test do
    output = shell_output("#{bin}/glasskube bootstrap --type slim 2>&1", 1)
    assert_match "Your kubeconfig file is either empty or missing!", output

    assert_match version.to_s, shell_output("#{bin}/glasskube --version")
  end
end
