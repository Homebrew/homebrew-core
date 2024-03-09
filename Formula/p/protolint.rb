class Protolint < Formula
  desc "Pluggable linter and fixer to enforce Protocol Buffer style and conventions"
  homepage "https://github.com/yoheimuta/protolint"
  url "https://github.com/yoheimuta/protolint/archive/refs/tags/v0.48.0.tar.gz"
  sha256 "f8cf133b89aca5e2ba24c9b2bcfc74e7ea4784f2978584fc710842139ea3e45e"
  license "MIT"
  head "https://github.com/yoheimuta/protolint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "54227b9b0d2343feb85f0a07ee4882b6b3e377b32efa368cf0768730af010c7f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3dc804769d72c51fc5a2e1c89c0accd37a510930855da63cbdf1053496d0679"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2104fad4b2bb87ad093a7df4c027f712518aecd32de56f13ee5ad6ab264eab32"
    sha256 cellar: :any_skip_relocation, sonoma:         "5ffe4ce895e788fe3d741f15d01887df8e115fdabf062bd426fd9e5c068a733b"
    sha256 cellar: :any_skip_relocation, ventura:        "5bff0d05343ff3f9d3cdaab310b92818fa2841428e44a41077c9557eba7eddd3"
    sha256 cellar: :any_skip_relocation, monterey:       "6ec4b80189cbc8ddd544bdf953111821301b4dbed1f5d2a7fe93781951dcef60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fdc8a4078df2c45c6ad27d2b8ddd96aa5eb1ed3ea7cbb6e03f6b51fa9efe72eb"
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
