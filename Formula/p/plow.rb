class Plow < Formula
  desc "High-performance and real-time metrics displaying HTTP benchmarking tool"
  homepage "https://github.com/six-ddc/plow"
  url "https://github.com/six-ddc/plow/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "a828641d9cf2876701e09865d259081a3005a29ea69391bda2fb6b1565489edf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "39ae40ee34b6fd5a0ac583152561e56db3d96a13e6c86613e8f0b7a7d3a0ce70"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65d432e948866ff0e5f31cc540f2e8e637d272eff116eb78bc621800e41965cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65d432e948866ff0e5f31cc540f2e8e637d272eff116eb78bc621800e41965cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "65d432e948866ff0e5f31cc540f2e8e637d272eff116eb78bc621800e41965cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf1c17517b61305a59fa751432db7398aa9d01f549d7bdcc0204e0d50a65821f"
    sha256 cellar: :any_skip_relocation, ventura:       "cf1c17517b61305a59fa751432db7398aa9d01f549d7bdcc0204e0d50a65821f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad04969ca26b96b3394e78b8a940eab678549a97fba6c051dc92ba82f7d646ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73cd9367711a8a191faafdf5782efa6b282a1f076b841e8218235c2b211c6a98"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    generate_completions_from_executable(bin/"plow", shell_parameter_format: "--completion-script-",
                                                     shells:                 [:bash, :zsh])
  end

  test do
    output = "2xx"
    assert_match output.to_s, shell_output("#{bin}/plow -n 1 https://httpbin.org/get")

    assert_match version.to_s, shell_output("#{bin}/plow --version")
  end
end
