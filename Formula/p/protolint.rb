class Protolint < Formula
  desc "Pluggable linter and fixer to enforce Protocol Buffer style and conventions"
  homepage "https://github.com/yoheimuta/protolint"
  url "https://github.com/yoheimuta/protolint/archive/refs/tags/v0.49.4.tar.gz"
  sha256 "9fa8176a70db939a496a44ddde8e7ba234ac2699d6e4fbcc48c333d856195f59"
  license "MIT"
  head "https://github.com/yoheimuta/protolint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "340988c24e1c0fd9a3d36ed43c0ecdf9b6267bea089aaf6cbf3324107b86d826"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "96e8bf01ccab465f1cb5f1ee6bf9dc9ef4f549d1c38db6f808ccbaf82d377aea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8755a4a7dc18179d24381d2070edb31967787419ca33185a6bc5db8cd6355704"
    sha256 cellar: :any_skip_relocation, sonoma:         "696d3dfce5837625c9b457dd166b791c1bdbe8674f63891cd14a017e4dd20516"
    sha256 cellar: :any_skip_relocation, ventura:        "fa49fc48bcb2ce474d737b724fffa979c5b57968da1d9068c1ca694d98b8b59e"
    sha256 cellar: :any_skip_relocation, monterey:       "59fbd63a001cf1a040c1fefe5ea9d5d93b86a8fde4a7ffc3384dc4fd88de0fcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "480a1fdc267bd4cc0682dbaac2ec97bd3d6bcfcfad6a2a5a9dbc5e20347e902e"
  end

  depends_on "go" => :build

  def install
    protolint_ldflags = %W[
      -s -w
      -X github.com/yoheimuta/protolint/internal/cmd.version=#{version}
      -X github.com/yoheimuta/protolint/internal/cmd.revision=#{tap.user}
    ]
    protocgenprotolint_ldflags = %W[
      -s -w
      -X github.com/yoheimuta/protolint/internal/cmd/protocgenprotolint.version=#{version}
      -X github.com/yoheimuta/protolint/internal/cmd/protocgenprotolint.revision=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags: protolint_ldflags), "./cmd/protolint"
    system "go", "build",
      *std_go_args(ldflags: protocgenprotolint_ldflags, output: bin/"protoc-gen-protolint"),
      "./cmd/protoc-gen-protolint"

    pkgshare.install Dir["_example/proto/*.proto"]
  end

  test do
    cp_r Dir[pkgshare/"*.proto"], testpath

    output = "[invalidFileName.proto:1:1] File name \"invalidFileName.proto\" " \
             "should be lower_snake_case.proto like \"invalid_file_name.proto\"."
    assert_equal output,
      shell_output("#{bin}/protolint lint #{testpath}/invalidFileName.proto 2>&1", 1).chomp

    output = "Quoted string should be \"other.proto\" but was 'other.proto'."
    assert_match output, shell_output("#{bin}/protolint lint #{testpath}/simple.proto 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/protolint version")
    assert_match version.to_s, shell_output("#{bin}/protoc-gen-protolint version")
  end
end
