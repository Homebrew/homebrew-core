class Kubespy < Formula
  desc "Tools for observing Kubernetes resources in realtime"
  homepage "https://github.com/pulumi/kubespy"
  url "https://github.com/pulumi/kubespy/archive/v0.6.1.tar.gz"
  sha256 "431f4b54ac3cc890cd3ddd0c83d4e8ae8a36cf036dfb6950b76577a68b6d2157"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0c4db20d09bcef468465226823d2b14af1e4a55206b16140248dfb306a69321f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "faff7e7c8eb84998d059df5dcc5e22d3da3be8cc5e524871c77f3acda36b7be6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "04129547313f403451674f831e6212aebeeae70479c5fe21cef03f06f4119c6c"
    sha256 cellar: :any_skip_relocation, ventura:        "eaa13f07ebf4369623a82014d55e1f92467f2651507334de7ea3d3c62b046d95"
    sha256 cellar: :any_skip_relocation, monterey:       "d8da458edd137ab26cfb3bc36d6c3ab7cf0404a11ca9a1b2c77f99fe08eb48d1"
    sha256 cellar: :any_skip_relocation, big_sur:        "bfc0e5e1537dc57fcdfa30af9526b395c148fde757078a3bf1ad0e0906dc239b"
    sha256 cellar: :any_skip_relocation, catalina:       "b103e94c9e8e673d5b5d731932dd7cfd7ce55d52a6fd937fe7c5e9de0cc71774"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f146884c3653f8be122d17740272b52c6377313df1054497f84fe4252f284df"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X github.com/pulumi/kubespy/version.Version=#{version}")

    generate_completions_from_executable(bin/"kubespy", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kubespy version")

    assert_match "invalid configuration: no configuration has been provided",
                 shell_output("#{bin}/kubespy status v1 Pod nginx 2>&1", 1)
  end
end
