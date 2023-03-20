class Crane < Formula
  desc "Tool for interacting with remote images and registries"
  homepage "https://github.com/google/go-containerregistry"
  url "https://github.com/google/go-containerregistry/archive/v0.14.0.tar.gz"
  sha256 "33ce5a1745c595b8cf7d9f231b7b7c8fea22a5f71c386fc8325d0e0c18bf686d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "62dc4b30a796d11b2fc04d4451615eb0ba8faf061ab7e41e3341a1c7acc78ef2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "62dc4b30a796d11b2fc04d4451615eb0ba8faf061ab7e41e3341a1c7acc78ef2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "62dc4b30a796d11b2fc04d4451615eb0ba8faf061ab7e41e3341a1c7acc78ef2"
    sha256 cellar: :any_skip_relocation, ventura:        "911b51e297b4e5490cdceb6e2500262152296d3f12daa133fdde2794893cae0c"
    sha256 cellar: :any_skip_relocation, monterey:       "911b51e297b4e5490cdceb6e2500262152296d3f12daa133fdde2794893cae0c"
    sha256 cellar: :any_skip_relocation, big_sur:        "911b51e297b4e5490cdceb6e2500262152296d3f12daa133fdde2794893cae0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b10cc1fe5e4761205a627122e30e6fb434af87e774815b5f3ccfe75825e532e"
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
