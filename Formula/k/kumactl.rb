class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/refs/tags/v2.14.1.tar.gz"
  sha256 "d86c3cb3fad4bdd58b42c5e3b55134f4f560388fa359a2d693a46733949366ea"
  license "Apache-2.0"
  head "https://github.com/kumahq/kuma.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ff4cf1cb9a76ba4ec5cf6fa2901d045c3fe4327277b64008d0078ac8de4ba4b1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "223a6f2ac8eb14fdade1a16b3d732795a4105fb1f022960a3ae719901b227494"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff4b93d8d9293c8bb78443202dfafa8ecccee101ab94123b062b0a244a676474"
    sha256 cellar: :any_skip_relocation, sonoma:        "8eceaeea138ed62c2395d130ada6d9d05c2565b6e65dc26c2cb66cdf5cb339d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8182fa607ca18f15e5d7bb3c89d58635cfecba5b95afd6077edadafa4244714"
    sha256 cellar: :any,                 x86_64_linux:  "f72cae9ed1cc8f81855b453ad21f3d5d2bd2920c02019d0731d087ab8463a223"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kumahq/kuma/v2/pkg/version.version=#{version}
      -X github.com/kumahq/kuma/v2/pkg/version.gitTag=#{version}
      -X github.com/kumahq/kuma/v2/pkg/version.buildDate=#{time.strftime("%F")}
    ]

    system "go", "build", *std_go_args(ldflags:), "./app/kumactl"

    generate_completions_from_executable(bin/"kumactl", shell_parameter_format: :cobra)
  end

  test do
    assert_match "Management tool for Kuma.", shell_output(bin/"kumactl")
    assert_match version.to_s, shell_output("#{bin}/kumactl version 2>&1")

    touch testpath/"config.yml"
    assert_match "Error: no resource(s) passed to apply",
    shell_output("#{bin}/kumactl apply -f config.yml 2>&1", 1)
  end
end
