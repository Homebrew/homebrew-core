class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://vektra.github.io/mockery/"
  url "https://github.com/vektra/mockery/archive/refs/tags/v3.7.1.tar.gz"
  sha256 "ef40f03633d02fe2817878e15c874b9bde1ed3467b778752f7bb89378e81996b"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "v3"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "88631925e0c1d31a85496780d4151fbdddf15d479e81eb0bf433ac90441aaff0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88631925e0c1d31a85496780d4151fbdddf15d479e81eb0bf433ac90441aaff0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88631925e0c1d31a85496780d4151fbdddf15d479e81eb0bf433ac90441aaff0"
    sha256 cellar: :any_skip_relocation, sonoma:        "da78c0d8a782d7281325e53532202f7a531a2ffec97e9493735017bc465a3c00"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "376d3e8211b83c08059b9f725ce81bbac8ec7201c1269419c80c1ecf799698a3"
    sha256 cellar: :any,                 x86_64_linux:  "6f255a012a1d461ddf78ff1ada4bcb853ce1d60bc47f72d1caa08905a525b70d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/vektra/mockery/v#{version.major}/internal/logging.SemVer=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"mockery", shell_parameter_format: :cobra)
  end

  test do
    (testpath/".mockery.yaml").write <<~YAML
      packages:
        github.com/vektra/mockery/v2/pkg:
          interfaces:
            TypesPackage:
    YAML
    output = shell_output("#{bin}/mockery 2>&1", 1)
    assert_match "Starting mockery", output
    assert_match "version=v#{version}", output
  end
end
