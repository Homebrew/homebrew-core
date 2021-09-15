class Crane < Formula
  desc "Tool for interacting with remote images and registries"
  homepage "https://github.com/google/go-containerregistry"
  url "https://github.com/google/go-containerregistry/archive/v0.6.0.tar.gz"
  sha256 "e9d9e9c662f6c9140083eb884bec9f2fc94554bb1d989aa6846e9cf2f69a27d5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1ee6c8238a5e4a08025a0b89f7deb81d1b92dbad227c718b8188cc5524769aef"
    sha256 cellar: :any_skip_relocation, big_sur:       "b95a968ba856bdb163b8a55bfe5d88308c3fc5f68e0f732e12fba0a947fd7496"
    sha256 cellar: :any_skip_relocation, catalina:      "622eb564e0cf74344e570722f144032caf795b0f65be6e897046add7abcf4ccf"
    sha256 cellar: :any_skip_relocation, mojave:        "41a0966f974b546da05413b9d16632e32852d8109a247d4cccfefe8c6bf03b72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63c3a660eeac1a72c066eb8f9cc4dd40b542686f247d031b4cda84830411b3bd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags",
      "-s -w -X github.com/google/go-containerregistry/cmd/crane/cmd.Version=#{version}",
      "./cmd/crane"
  end

  test do
    json_output = shell_output("#{bin}/crane manifest gcr.io/go-containerregistry/crane")
    manifest = JSON.parse(json_output)
    assert_equal manifest["schemaVersion"], 2
  end
end
