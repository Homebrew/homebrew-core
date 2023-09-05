class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://github.com/istio/istio/archive/refs/tags/1.18.2.tar.gz"
  sha256 "f0f9b7bda20cd8af7e7cebfa1704f0eca2ae32581057664d27c92f87dcd20e1e"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "532084c6e7c03a8ad7ecd9b9ac57c4073a0f77e4b69f15a539c3cfaa48d26b47"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8f61a551170576b6bf383df5d8d2024edc5e71d0b01ad74c09d51c9521a7562"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f231eef7d232b7ae518bcf94020f20769d3d3fb2e6ecfb0b8a0f72046616627c"
    sha256 cellar: :any_skip_relocation, ventura:        "8a2b23a5b7a4c75474839ae6dd23856eab84ac61e9aab130c0a7c77be251cc25"
    sha256 cellar: :any_skip_relocation, monterey:       "21ede30fd7a36bf71c8626b15cec4b0195571228d2cbfaf50fb8aed37174acc0"
    sha256 cellar: :any_skip_relocation, big_sur:        "a689004d2dbde0dd5d74a54ef3c736434626921f3d37eb92065f7d0c41150e0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38e20eb724c231f7dc5d478f1a4a05b811093d81b014f5779d5fc7d752ebbf2c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X istio.io/pkg/version.buildVersion=#{version}
      -X istio.io/pkg/version.buildStatus=#{tap.user}
      -X istio.io/pkg/version.buildTag=#{version}
      -X istio.io/pkg/version.buildHub=docker.io/istio
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./istioctl/cmd/istioctl"

    generate_completions_from_executable(bin/"istioctl", "completion")
    system bin/"istioctl", "collateral", "--man"
    man1.install Dir["*.1"]
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/istioctl version --remote=false").strip
  end
end
