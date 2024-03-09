class Protolint < Formula
  desc "Pluggable linter and fixer to enforce Protocol Buffer style and conventions"
  homepage "https://github.com/yoheimuta/protolint"
  url "https://github.com/yoheimuta/protolint/archive/refs/tags/v0.48.0.tar.gz"
  sha256 "f8cf133b89aca5e2ba24c9b2bcfc74e7ea4784f2978584fc710842139ea3e45e"
  license "MIT"
  head "https://github.com/yoheimuta/protolint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4bbb5f3ba78da25aa3ae9c7b057e7cb90f6cd15a4a54e9aab8664c66267d5bc9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "82a8be44f6150d88c93d48f61f5e8034f4ba158689911a0cce77fce3a55cb592"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f9a60f2fc6296d00b9a71a3014259a23f997ef5478dcc3b9f3fe1e3aa75cbb8"
    sha256 cellar: :any_skip_relocation, sonoma:         "a61c2cf6cf798b74ec430b53cf511f2e12b411e953f0e0196140c7995959a645"
    sha256 cellar: :any_skip_relocation, ventura:        "7a2e8ade8f34a1f56ad9bbd129f5b75e5aeed1852986b90c74599bb2733c3ef4"
    sha256 cellar: :any_skip_relocation, monterey:       "9aa04b1d2b500cc40668cac08e15252a8579eb43694dca2cda72910052ef789f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8eca83400845b7dcc6824a8296de2cb03e02eae526b724265e48a3258e962d0a"
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
