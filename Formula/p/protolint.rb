class Protolint < Formula
  desc "Pluggable linter and fixer to enforce Protocol Buffer style and conventions"
  homepage "https://github.com/yoheimuta/protolint"
  url "https://github.com/yoheimuta/protolint/archive/refs/tags/v0.49.8.tar.gz"
  sha256 "fa84c2161936d6dd001b452cf6c59c8090c92fc022fca664c25b959ee33fb25a"
  license "MIT"
  head "https://github.com/yoheimuta/protolint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "53bdd2d057e9c7f241626076de3991eec79e2faff522203e816c17f7fdd47d71"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bca83adf10d0021a24af3617a8acf0a71306df442b9cc6910ee93c126e4ffcf4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9234cea2271336207b50735989beb3e23c88f2c1836d89dc0d5ba0c7fa62982"
    sha256 cellar: :any_skip_relocation, sonoma:         "eb210c4e2f2820ae08a079dfa2df41ee058fd25727b8d8c30d9abfe843b3f907"
    sha256 cellar: :any_skip_relocation, ventura:        "4990b08f8fb1fd477c74796a7dceb2dc9e98bea27a5f72cc6ce6ef31edb0857e"
    sha256 cellar: :any_skip_relocation, monterey:       "1fcc605276abc0c4cd2c9e2a1aea692953fc24ea3f6ac274185bf6bc0c065250"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29d79ebf451dc9c5374b94b3777acac38631a523c90571c65847f13219cb690a"
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
