class Crane < Formula
  desc "Tool for interacting with remote images and registries"
  homepage "https://github.com/google/go-containerregistry"
  url "https://github.com/google/go-containerregistry/archive/refs/tags/v0.20.6.tar.gz"
  sha256 "53f17964ade63f63b2c66231a6e1ea606345cfcc325e49a5267017bb475bdcb4"
  license "Apache-2.0"
  head "https://github.com/google/go-containerregistry.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf1acaf4cde02176b9f0a3684e4d062b9cc8758977ee056dfbcab5cd2fae028f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf1acaf4cde02176b9f0a3684e4d062b9cc8758977ee056dfbcab5cd2fae028f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bf1acaf4cde02176b9f0a3684e4d062b9cc8758977ee056dfbcab5cd2fae028f"
    sha256 cellar: :any_skip_relocation, sonoma:        "693d1829b69430956cfcfc35a90e0f2b2099fbf2b50a8ec05389f45e2502d9b1"
    sha256 cellar: :any_skip_relocation, ventura:       "693d1829b69430956cfcfc35a90e0f2b2099fbf2b50a8ec05389f45e2502d9b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82c5b30322c819286dc77c9f3af7e04ba387a3a0358e6fabf23325fba2f43542"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/google/go-containerregistry/cmd/crane/cmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/crane"

    generate_completions_from_executable(bin/"crane", "completion")
  end

  test do
    json_output = shell_output("#{bin}/crane manifest gcr.io/go-containerregistry/crane")
    manifest = JSON.parse(json_output)
    assert_equal manifest["schemaVersion"], 2
  end
end
