class Protolint < Formula
  desc "Pluggable linter and fixer to enforce Protocol Buffer style and conventions"
  homepage "https://github.com/yoheimuta/protolint"
  url "https://github.com/yoheimuta/protolint.git",
      tag:      "v0.45.2",
      revision: "12b0300f541c9f0d2f4fa695827a8e80daffe9be"
  license "MIT"
  head "https://github.com/yoheimuta/protolint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bfc8c18833d3fafa74aab1aed220e26517f5a04e14c6883e669153e6feb4ee8e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b4c7bdc6c3b4c3bd185651e1100588fb87eefbb6f18f4294fb5a61892bab05e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fd2c6cc60a76d057b736e66678c231eba84a7851d52620c15c2d8ad8ff6149aa"
    sha256 cellar: :any_skip_relocation, ventura:        "d0f5afde7cdb8d53bfb4197bc9d191c11ad28e894eb976131097db21efa75389"
    sha256 cellar: :any_skip_relocation, monterey:       "f6d8734c8d22e4196889f89735d1950a985c7c1a399135ecd6b73f6b2bd820e6"
    sha256 cellar: :any_skip_relocation, big_sur:        "c95e62755cda1bd919d183ccb1ece4de2c3a36f5830f07af1fc65fdbdf4a68b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a324594519a7d0fd1965ba9db4385753fc41351177f5b04bae4867e1dcd314ed"
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
