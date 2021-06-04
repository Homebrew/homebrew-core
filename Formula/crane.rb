class Crane < Formula
  desc "Tool for interacting with remote images and registries"
  homepage "https://github.com/google/go-containerregistry"
  url "https://github.com/google/go-containerregistry/archive/v0.5.1.tar.gz"
  sha256 "c3e28d8820056e7cc870dbb5f18b4f7f7cbd4e1b14633a6317cef895fdb35203"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bad59b16b56a5f718c38c1d2eafbd149c7d085182d44c39342d77f37fd12ec3b"
    sha256 cellar: :any_skip_relocation, big_sur:       "4d4b05be67c7a8699be6843a8b453361ef2dc9aefc54066fa6db1c855bc0b5df"
    sha256 cellar: :any_skip_relocation, catalina:      "d306248c9591b594077728f9f20514b0d451e631ba48d4f639506e583e584e34"
    sha256 cellar: :any_skip_relocation, mojave:        "5a68f903155a28ac78c1fa39c4fcae394bd87133e9bb65551caa05a4e7fec412"
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
