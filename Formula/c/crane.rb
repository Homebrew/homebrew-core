class Crane < Formula
  desc "Tool for interacting with remote images and registries"
  homepage "https://github.com/google/go-containerregistry"
  url "https://github.com/google/go-containerregistry/archive/refs/tags/v0.21.5.tar.gz"
  sha256 "c2291876a087f93a61b561594a389e6543091c0c5c50f16b5f9c14417d2fc947"
  license "Apache-2.0"
  head "https://github.com/google/go-containerregistry.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed3d8e4ada4febd347f40a114df65e004e0c49b2f5ded98d066d8333eadb16b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed3d8e4ada4febd347f40a114df65e004e0c49b2f5ded98d066d8333eadb16b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed3d8e4ada4febd347f40a114df65e004e0c49b2f5ded98d066d8333eadb16b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "4145a93b20ae6136f6e1e09c884f76e7fd3579cdc9fd3ef6d7b23a8ad3a1ea61"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85a9939f2cc6ab3ad972ad6eee8f6358b542098bb163dbea631466c829bfdf57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d5f8ea6cfbfe70b7beadd64beb674e36b564ed4c15e3d38d9f9d4f19ee080ca"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/google/go-containerregistry/cmd/crane/cmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/crane"

    generate_completions_from_executable(bin/"crane", shell_parameter_format: :cobra)
  end

  test do
    json_output = shell_output("#{bin}/crane manifest gcr.io/go-containerregistry/crane")
    manifest = JSON.parse(json_output)
    assert_equal manifest["schemaVersion"], 2
  end
end
