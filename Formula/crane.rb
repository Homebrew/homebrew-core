class Crane < Formula
  desc "Tool for interacting with remote images and registries"
  homepage "https://github.com/google/go-containerregistry"
  url "https://github.com/google/go-containerregistry/archive/v0.4.0.tar.gz"
  sha256 "90ddaaf4a6b76c490e0664a55946342055ba70c0ed40d52724440fa8ac0b45db"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags",
      "-s -w -X github.com/google/go-containerregistry/cmd/crane/cmd.Version=#{version}",
      "./cmd/crane"
  end

  test do
    json_output = shell_output("#{bin}/crane manifest homebrew/brew")
    manifest = JSON.parse(json_output)
    assert_equal manifest["schemaVersion"], 2
    assert_equal manifest["config"]["mediaType"], "application/vnd.docker.container.image.v1+json"
  end
end
