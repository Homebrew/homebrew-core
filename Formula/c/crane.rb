class Crane < Formula
  desc "Tool for interacting with remote images and registries"
  homepage "https://github.com/google/go-containerregistry"
  url "https://github.com/google/go-containerregistry/archive/refs/tags/v0.20.7.tar.gz"
  sha256 "623a87ec77206bae301a9af64b42ba05e602b1608d0ee3574749b348ab4dd7ac"
  license "Apache-2.0"
  head "https://github.com/google/go-containerregistry.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d1eb007d46a20d7951ed9d0c7bbc0ce26a27e2aa576b08cd25e68017e361194a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1eb007d46a20d7951ed9d0c7bbc0ce26a27e2aa576b08cd25e68017e361194a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1eb007d46a20d7951ed9d0c7bbc0ce26a27e2aa576b08cd25e68017e361194a"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c31eef5c2fa3efbd01c6df8cda5d4ffbc3acd1a6763b707e43134306f90ba56"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c1d172bcede0ef610c4cc5fd7b7ed8c6855f220f013a6f622821f8c20ba9d18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78bb2e5add10e20cef5621b5fff2483e5821faa75fdafb6300279cde599450ae"
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
