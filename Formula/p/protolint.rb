class Protolint < Formula
  desc "Pluggable linter and fixer to enforce Protocol Buffer style and conventions"
  homepage "https://github.com/yoheimuta/protolint"
  url "https://github.com/yoheimuta/protolint/archive/refs/tags/v0.54.1.tar.gz"
  sha256 "3082d88e3c17a88f3001ffc6849eacd9075a0f847ed6339f81e4f80dd0007751"
  license "MIT"
  head "https://github.com/yoheimuta/protolint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1858bc0cf62941c36d1a4b2539b1b353244723784d47eee8715bc5f84311d026"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1858bc0cf62941c36d1a4b2539b1b353244723784d47eee8715bc5f84311d026"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1858bc0cf62941c36d1a4b2539b1b353244723784d47eee8715bc5f84311d026"
    sha256 cellar: :any_skip_relocation, sonoma:        "461a8cd7dd0d5e308a7faf63f1ac4f5f36f7b86097a0248f2fd9ed424504e098"
    sha256 cellar: :any_skip_relocation, ventura:       "461a8cd7dd0d5e308a7faf63f1ac4f5f36f7b86097a0248f2fd9ed424504e098"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09834887e8f94eba8a7a64821c166434078e8cdd31fa186b3e3200ce4518a985"
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
