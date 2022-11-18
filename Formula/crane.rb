class Crane < Formula
  desc "Tool for interacting with remote images and registries"
  homepage "https://github.com/google/go-containerregistry"
  url "https://github.com/google/go-containerregistry/archive/v0.12.1.tar.gz"
  sha256 "6f8060933ace2acff468ce17359aa858b7ca3db049ed8d0ac5d4ae62359573c3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ee15286bbbd8f37159c82a1c88e0c65a53c9573b4ee07e2b459e057b235c046d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a7ac13f91c7af9d7c9f95b1833ed7b9ac4bd71ff855bd93e4c95dfbfe050077"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9d1ed2a72a9d686e7db19a70a8705f7310f84debed78444c7837eb78b0f5f059"
    sha256 cellar: :any_skip_relocation, ventura:        "2cbbfa1272340ef473df76655ee9d1f167b02865afb1443ca6b4ae79c9b7d8f5"
    sha256 cellar: :any_skip_relocation, monterey:       "d5b0ef8390b39eed471081a4c4ee105122e2f585535290f19dda36c212a96ce0"
    sha256 cellar: :any_skip_relocation, big_sur:        "76de07d96ee16e0890090ca16825c43592257c47d0b062859befec6ece942e75"
    sha256 cellar: :any_skip_relocation, catalina:       "505afd464da89511d84dafe77f02fdea2f5bff33555eafb3527cd1fc9ff8bd23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5449a04a47d6628c80f376eba8c429f840c57d04f2689661b2e200f9da755526"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/google/go-containerregistry/cmd/crane/cmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/crane"

    generate_completions_from_executable(bin/"crane", "completion")
  end

  test do
    json_output = shell_output("#{bin}/crane manifest gcr.io/go-containerregistry/crane")
    manifest = JSON.parse(json_output)
    assert_equal manifest["schemaVersion"], 2
  end
end
