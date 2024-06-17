class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.10.7.tar.gz"
  sha256 "9aaa96f5423563f59056dafb24d35aa8901f738416597cc6ef8f583a6ea71cd2"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e9dc0fa55b3cdc80ac9d8c14f819be2025844135a7948dd08bf0e9a8f3576e72"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4065fa143714f8c41cfff6be55f078f556156c0de5d586f73075a59c779b9589"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08d8b33de287566548910f29fde27059a19154d5a960924e64fd8c538aea8136"
    sha256 cellar: :any_skip_relocation, sonoma:         "0fb634591c3cb6fb106d4f3fa986f69cf95d8d105f0932c6f4e335a8391f59af"
    sha256 cellar: :any_skip_relocation, ventura:        "09f7ad55b77f81c885cc24c895490eafe26a513baa191fcd9bfdb30c8214886f"
    sha256 cellar: :any_skip_relocation, monterey:       "74f0c4435b38d14d140ebfeae2698679ba740fe20bc4fed461d0fa53b2d3aff8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a6d8fa16551703520cd763105cb8b1a8e056803a1ca5314ddc97db10e3ff9c4"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kosli-dev/cli/internal/version.version=#{version}
      -X github.com/kosli-dev/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/kosli-dev/cli/internal/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin/"kosli", ldflags:), "./cmd/kosli"

    generate_completions_from_executable(bin/"kosli", "completion", base_name: "kosli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kosli version")

    assert_match "OK", shell_output("#{bin}/kosli status")
  end
end
