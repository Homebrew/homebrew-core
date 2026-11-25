class Protolint < Formula
  desc "Pluggable linter and fixer to enforce Protocol Buffer style and conventions"
  homepage "https://github.com/yoheimuta/protolint"
  url "https://github.com/yoheimuta/protolint/archive/refs/tags/v0.59.1.tar.gz"
  sha256 "dc8c48dc380f8ee362b7855c5677cc076995bcaf8633bf2b731add0f6052c0ff"
  license "MIT"
  head "https://github.com/yoheimuta/protolint.git", branch: "master"

  bottle do
    manifest_sha256 "dedb2169e51bcdaf4720726e66accdacd44e98535ba602dc8bf8d2cb736d66dd"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "39a8d3b7e7b125ffb3870f4128603dfb14e24dd0439b01ed3353adfa87dfcf30"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "39a8d3b7e7b125ffb3870f4128603dfb14e24dd0439b01ed3353adfa87dfcf30"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "39a8d3b7e7b125ffb3870f4128603dfb14e24dd0439b01ed3353adfa87dfcf30"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a3c454a878a2d4c5fad4330b635396241c4bcd21c05e0eea5dba83eddd2c921c"
    sha256 cellar: :any,                 x86_64_linux:      "875ce1d63a62881f03139a1ad8f2c9404c6f7f8c0b5ea8a4eca7d1b79d1afdb8"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    protolint_ldflags = %W[
      -X github.com/yoheimuta/protolint/internal/cmd.version=#{version}
      -X github.com/yoheimuta/protolint/internal/cmd.revision=#{tap.user}
    ]
    protocgenprotolint_ldflags = %W[
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
