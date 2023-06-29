class Protolint < Formula
  desc "Pluggable linter and fixer to enforce Protocol Buffer style and conventions"
  homepage "https://github.com/yoheimuta/protolint"
  url "https://github.com/yoheimuta/protolint.git",
      tag:      "v0.45.0",
      revision: "4dd3e2de67206ce5b117780c680a001f52198e59"
  license "MIT"
  head "https://github.com/yoheimuta/protolint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ac6cdf750ca8de8049134e5fd4c73a1e5be72adbd72c9e6f648df7292c6cabb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ac6cdf750ca8de8049134e5fd4c73a1e5be72adbd72c9e6f648df7292c6cabb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6ac6cdf750ca8de8049134e5fd4c73a1e5be72adbd72c9e6f648df7292c6cabb"
    sha256 cellar: :any_skip_relocation, ventura:        "352196098344256261fde764c408c657e72a0eb57f13f42dc19b02b92960e04d"
    sha256 cellar: :any_skip_relocation, monterey:       "352196098344256261fde764c408c657e72a0eb57f13f42dc19b02b92960e04d"
    sha256 cellar: :any_skip_relocation, big_sur:        "352196098344256261fde764c408c657e72a0eb57f13f42dc19b02b92960e04d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c2a9e5d99ef4172adbb9a66e689a3011e28fa9179d2e6811210209cda036ab6"
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
