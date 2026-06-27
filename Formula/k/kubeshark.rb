class Kubeshark < Formula
  desc "API Traffic Analyzer providing real-time visibility into Kubernetes network"
  homepage "https://kubeshark.com"
  url "https://github.com/kubeshark/kubeshark/archive/refs/tags/v53.3.0.tar.gz"
  sha256 "cea29386279ab0a9e73bb20002fc5387febc373692eb6047cb1d08c131431b2d"
  license "Apache-2.0"
  head "https://github.com/kubeshark/kubeshark.git", branch: "master"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f02106e34c8fb8c9d2e09d7f04f0728b6b90fc87dcdf8d065c9d9e3f1d541119"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d0bd9475f33975c12760d15d5cae5dc5d5be1aa98a63de09f147153ef85135e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f04761f585f8c66e06f56f8d2b8f60462eaf65c05d2fda9ca023bb41f2f11d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "524c883d22388e6788b8e24b33e2c5d37e163c5d26bc4c4cc27935d19c8b8b10"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81a88a8b827d612f3d5e95414af783abd396e09e75f4bd02a476ff1fe24a4023"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "660034a79fba1d1adf5abb1286a5798a24ed6a1371a4ed529c45e3705a29dbd9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X "github.com/kubeshark/kubeshark/misc.Platform=#{OS.kernel_name}_#{Hardware::CPU.arch}"
      -X "github.com/kubeshark/kubeshark/misc.BuildTimestamp=#{time}"
      -X "github.com/kubeshark/kubeshark/misc.Ver=v#{version}"
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kubeshark", shell_parameter_format: :cobra)
  end

  test do
    version_output = shell_output("#{bin}/kubeshark version")
    assert_equal "v#{version}", version_output.strip

    tap_output = shell_output("#{bin}/kubeshark tap 2>&1")
    assert_match ".kube/config: no such file or directory", tap_output
  end
end
