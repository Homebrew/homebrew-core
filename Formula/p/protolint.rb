class Protolint < Formula
  desc "Pluggable linter and fixer to enforce Protocol Buffer style and conventions"
  homepage "https://github.com/yoheimuta/protolint"
  url "https://github.com/yoheimuta/protolint/archive/refs/tags/v0.49.2.tar.gz"
  sha256 "d7ac871e52b01be0e43142dda02eac71e683e8467d4f691daa38a3c1f0a59ac7"
  license "MIT"
  head "https://github.com/yoheimuta/protolint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "447e03cba0347f58656bfe5b5c0d8e8c2e1609b8fbf361b4e58dc405c19badef"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6d403e9e073f59c58e5e0dbc35bb3f030a4579bb1893750b745fa93acd0e7b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "637a896d4c2246a6f3bf73774ec27a273b97e2edbcce5bdbe5b0cb07102dcb1a"
    sha256 cellar: :any_skip_relocation, sonoma:         "04f411b59ac87d077dd7317bfd76761c750c80498266a0c48f6f5b3e05d854e4"
    sha256 cellar: :any_skip_relocation, ventura:        "8f9851f47aff27b02478c03f292d3eb76fa738b9bcc593a8c757b58ba4f188c7"
    sha256 cellar: :any_skip_relocation, monterey:       "c9391bcfccc6c767ac962d5db53006a2645dcf4f0a8a1d1baf420b5e828023b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a13b90b64f5c571c17b0406e8b6aaf31c71dbf526466123134d8c52f00f5de3"
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
