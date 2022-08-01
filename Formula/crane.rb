class Crane < Formula
  desc "Tool for interacting with remote images and registries"
  homepage "https://github.com/google/go-containerregistry"
  url "https://github.com/google/go-containerregistry/archive/v0.11.0.tar.gz"
  sha256 "e2eac75200a38f9fecdd8a6b80a839a50898e3539e5625c2150f6d5d31317ade"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26f8c6f1c635dab0421af1b4c9f40ec2418242c3cf43c1d1ccd3d611e941fa45"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8016c49019324822bef82954b1a4d9cbb2f9ac947d6a0e8bbfe5549ad6e78941"
    sha256 cellar: :any_skip_relocation, monterey:       "87ebc1f1c9a4d2a3c2162220808ce629bc56a7c5ad890183a2139fdef41b1344"
    sha256 cellar: :any_skip_relocation, big_sur:        "f106c73fd08b854ec58b2afc53953d2559d287d930673488ca95a986933b4b42"
    sha256 cellar: :any_skip_relocation, catalina:       "01cd5575be8eee5cf44912a5a074171469fc5f82458316d2425d4774f2e3eb04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f196ac7230485c16733a7fc9d090430f3f13ae828843d3671cb0e3823c55bf31"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/google/go-containerregistry/cmd/crane/cmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/crane"
  end

  test do
    json_output = shell_output("#{bin}/crane manifest gcr.io/go-containerregistry/crane")
    manifest = JSON.parse(json_output)
    assert_equal manifest["schemaVersion"], 2
  end
end
