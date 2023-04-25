class Protolint < Formula
  desc "Pluggable linter and fixer to enforce Protocol Buffer style and conventions"
  homepage "https://github.com/yoheimuta/protolint"
  url "https://github.com/yoheimuta/protolint.git",
      tag:      "v0.43.2",
      revision: "b5befc0ea3b1e0ab3eb602ae878ed103079e93b1"
  license "MIT"
  head "https://github.com/yoheimuta/protolint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "569592d3e173193cec7e321bbd6d550c338703c29c0cfea9e1a35070d7c253da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "569592d3e173193cec7e321bbd6d550c338703c29c0cfea9e1a35070d7c253da"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "569592d3e173193cec7e321bbd6d550c338703c29c0cfea9e1a35070d7c253da"
    sha256 cellar: :any_skip_relocation, ventura:        "5fed478937d58231ca78eaeb90e1426c780165405ceb490c5fd26cf924f194a8"
    sha256 cellar: :any_skip_relocation, monterey:       "5fed478937d58231ca78eaeb90e1426c780165405ceb490c5fd26cf924f194a8"
    sha256 cellar: :any_skip_relocation, big_sur:        "5fed478937d58231ca78eaeb90e1426c780165405ceb490c5fd26cf924f194a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0733a0cf47928abd073bcb7bafb3f5ace6c29826ac826ac555b4136dbe1197c4"
  end

  depends_on "go" => :build

  def install
    protolint_ldflags = %W[
      -s -w
      -X github.com/yoheimuta/protolint/internal/cmd.version=#{version}
      -X github.com/yoheimuta/protolint/internal/cmd.revision=#{Utils.git_head(length: 8)}
    ]
    protocgenprotolint_ldflags = %W[
      -s -w
      -X github.com/yoheimuta/protolint/internal/cmd/protocgenprotolint.version=#{version}
      -X github.com/yoheimuta/protolint/internal/cmd/protocgenprotolint.revision=#{Utils.git_head(length: 8)}
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
