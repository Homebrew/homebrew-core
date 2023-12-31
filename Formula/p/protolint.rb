class Protolint < Formula
  desc "Pluggable linter and fixer to enforce Protocol Buffer style and conventions"
  homepage "https://github.com/yoheimuta/protolint"
  url "https://github.com/yoheimuta/protolint.git",
      tag:      "v0.47.4",
      revision: "2f86d18771d823c48735989d3f82793e520a842e"
  license "MIT"
  head "https://github.com/yoheimuta/protolint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "42e29a4d1f81b81ab34ca0b8a836d39446821119b81a8fb8e0d5e28d9de7fed7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "275f6ebe0dc2e8ec8b2b4220a7bfa01313944b1cf4c4c4b129c9ab07cd4221ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8ca1add4ca4e32b1d2672da4b8cb2c3925c7eaa8815d0f2cd7377aea11ad7e0"
    sha256 cellar: :any_skip_relocation, sonoma:         "a0be26d824b048e17be140043d3080892d2adf3c9723d594fe5926535ae52fa9"
    sha256 cellar: :any_skip_relocation, ventura:        "ff4557a2ef57788a7491dfb236831d8a223e08de09199726659b60b3c22c2ca5"
    sha256 cellar: :any_skip_relocation, monterey:       "82f98029b37024f31a9b2ed92cc1944a6d5c234720f0819b30d68a51d1c12baa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e509bcbe1f71a7fa034f5b147283b01441110c00c6c8880873c4035bd8deec0"
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
