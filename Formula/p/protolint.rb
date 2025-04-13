class Protolint < Formula
  desc "Pluggable linter and fixer to enforce Protocol Buffer style and conventions"
  homepage "https://github.com/yoheimuta/protolint"
  url "https://github.com/yoheimuta/protolint/archive/refs/tags/v0.53.0.tar.gz"
  sha256 "96cd7e7c5858956cad9d72a54fbb34890683c3facfe7d6ff5f2a1c008de03b76"
  license "MIT"
  head "https://github.com/yoheimuta/protolint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "491e70de1c0a108e1c4f3c5bf643e57ef598238cc2bccc96c04f269a7547aa97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "491e70de1c0a108e1c4f3c5bf643e57ef598238cc2bccc96c04f269a7547aa97"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "491e70de1c0a108e1c4f3c5bf643e57ef598238cc2bccc96c04f269a7547aa97"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f72556f8744c63513c9e3705c577e59e96006b1718d4aacb6609acb7e94caca"
    sha256 cellar: :any_skip_relocation, ventura:       "9f72556f8744c63513c9e3705c577e59e96006b1718d4aacb6609acb7e94caca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "daac4ad409229cc41d802863c1f5434afb04833581b280a26277c287ce798d1f"
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
