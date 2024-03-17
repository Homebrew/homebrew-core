class Protolint < Formula
  desc "Pluggable linter and fixer to enforce Protocol Buffer style and conventions"
  homepage "https://github.com/yoheimuta/protolint"
  url "https://github.com/yoheimuta/protolint/archive/refs/tags/v0.49.3.tar.gz"
  sha256 "3cd0e84c535fb559fd8cd112ce0691f027927dc73a5e700f1ed279d8d052c2af"
  license "MIT"
  head "https://github.com/yoheimuta/protolint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c5de9ba646beb7b2a4fde681320eadfe6f4beb164411451f0b99605cb126ccc6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4891ba88e44f06488af0e7a21dca74fff2060b7f40c4303a9a854b6c3b178a68"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b588d4af80716ddaedd7f72ff185fd8c733ffa881dc26e1b82763dae84da18c"
    sha256 cellar: :any_skip_relocation, sonoma:         "1336591a6dbe4a961b1731d02962f4651180e96ad84487e506866b827bbadef8"
    sha256 cellar: :any_skip_relocation, ventura:        "30aef084a205e46120a57416ad22e64c61d11bad59df7d02a49be34330635054"
    sha256 cellar: :any_skip_relocation, monterey:       "49615c6edafe29dd6d3f54a413086de39ffe20902467cdf7f40e6bbb62a83b68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9ca5dc6d938d9f86626118b3b261b1e46d3328b8c4c0af7eb8a4ea801d0fbdd"
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
