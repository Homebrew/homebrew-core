class Crane < Formula
  desc "Tool for interacting with remote images and registries"
  homepage "https://github.com/google/go-containerregistry"
  url "https://github.com/google/go-containerregistry/archive/v0.15.1.tar.gz"
  sha256 "003f1ec639ed7347101ba95fc2b1aa36e51fb7a286488110cb7e1d8dd4a851a9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5d04068efe9fa6d57168b90c453b7e17888bae55f4c02f1dcf5c1d26bf74099"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5d04068efe9fa6d57168b90c453b7e17888bae55f4c02f1dcf5c1d26bf74099"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d5d04068efe9fa6d57168b90c453b7e17888bae55f4c02f1dcf5c1d26bf74099"
    sha256 cellar: :any_skip_relocation, ventura:        "1903eb3e684e2f378d353a92029c066ec27b3fe6a3949d000561148f3ff04193"
    sha256 cellar: :any_skip_relocation, monterey:       "1903eb3e684e2f378d353a92029c066ec27b3fe6a3949d000561148f3ff04193"
    sha256 cellar: :any_skip_relocation, big_sur:        "1903eb3e684e2f378d353a92029c066ec27b3fe6a3949d000561148f3ff04193"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "abda678eec78f1dc5e351431e0f627ebf252ee3a91f2dca6ed31ef525eb1c836"
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
