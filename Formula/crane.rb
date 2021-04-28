class Crane < Formula
  desc "Tool for interacting with remote images and registries"
  homepage "https://github.com/google/go-containerregistry"
  url "https://github.com/google/go-containerregistry/archive/v0.5.0.tar.gz"
  sha256 "106af414bd6eb60f190bd2363d63f84c4f107365f34395e5827d03b6ba8717ce"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "747eb1fde14926d51fb07fed9dd7f3bf34416c39bcf2d3151a3b742f66f7b38e"
    sha256 cellar: :any_skip_relocation, big_sur:       "319e61c56ca16f9ddb36264ff903c82c90f27023820f9f267d4c569f5f6cb18f"
    sha256 cellar: :any_skip_relocation, catalina:      "2fb63e2a8355d88d83f02f39c8c088d91d184abb4ac434af43c4e54107e04bee"
    sha256 cellar: :any_skip_relocation, mojave:        "835e2ec55f5defd87c638af9efb366385b13806aa325085c0befec5a237a1ebd"
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
