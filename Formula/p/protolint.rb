class Protolint < Formula
  desc "Pluggable linter and fixer to enforce Protocol Buffer style and conventions"
  homepage "https://github.com/yoheimuta/protolint"
  url "https://github.com/yoheimuta/protolint/archive/refs/tags/v0.56.4.tar.gz"
  sha256 "c513f7fbd712b2079c2b646252eab7d75d714337c369a5b77a8dfda133d5b27d"
  license "MIT"
  head "https://github.com/yoheimuta/protolint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ddf06ae37f281ddd466bc53193e7f3adb78a9781d498454ad02a08eabfcdffc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7afab0c2bf2eabdfe873483fd2683056765a488d1f6f56eeecda301b752e2fc8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7afab0c2bf2eabdfe873483fd2683056765a488d1f6f56eeecda301b752e2fc8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7afab0c2bf2eabdfe873483fd2683056765a488d1f6f56eeecda301b752e2fc8"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc91cad8bb74a6282339793fcac0d9f69b9cfa64679aaa62b996c6a3e6b64ae1"
    sha256 cellar: :any_skip_relocation, ventura:       "bc91cad8bb74a6282339793fcac0d9f69b9cfa64679aaa62b996c6a3e6b64ae1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50ea3b0ea97b6f1706fa2552a34e6a74e78660cd22eaf84cac12f5891a7bfaea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e9ad1c4fa4fe3bd3259266444237c81538570c920eeb4f6a7d8bc45578a258a"
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
