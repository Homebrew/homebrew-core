class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/refs/tags/v2.14.3.tar.gz"
  sha256 "289b85e3175b161b5d99b52eb5ae958a17370e8f282fcbfb6f1deccc44d324e9"
  license "Apache-2.0"
  head "https://github.com/kumahq/kuma.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6987e7fccbff3c3c4d0f9bfeda04d09370c22875691548b297d2eb34c0e6db25"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d169832491b14450a64aefae444bd71186855adbb658052f199c1f5685535cbd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00f8e1c852e5b4ff9537bff304742ff20c862416183ad80287cec90c03a6ce92"
    sha256 cellar: :any_skip_relocation, sonoma:        "5dcc66fb8c4d1b6e4edc3c365da91a60032db41b2f3a46c9b9810ab17034e214"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "275a70d676b3b7e443cb86b7507b8541f9b31f0a3d4fa7a5b0e5c40bb1fe75a1"
    sha256 cellar: :any,                 x86_64_linux:  "26ae945656d9e88a00a4641bc2316600b14f3999681613efe0ea4461981202e6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
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
