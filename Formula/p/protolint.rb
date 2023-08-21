class Protolint < Formula
  desc "Pluggable linter and fixer to enforce Protocol Buffer style and conventions"
  homepage "https://github.com/yoheimuta/protolint"
  url "https://github.com/yoheimuta/protolint.git",
      tag:      "v0.46.0",
      revision: "ad00a18de409c463d0ff00ad4f6709998f48c19f"
  license "MIT"
  head "https://github.com/yoheimuta/protolint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8ee97de0d5478f128e5231fd4ed780b86d44448d6c0bac84d5302368543d251c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a85b23728fc08c489a377039a9cc219eda8de5763168baef998616d872d978ae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1fd4df565811c4d639437c4f50bb1af5f768212c852d4690cffee0903dee8401"
    sha256 cellar: :any_skip_relocation, ventura:        "caf3c9deb352d764310af7ee7f4e1e326cea73da06f5cf01e2930a2558f0d48f"
    sha256 cellar: :any_skip_relocation, monterey:       "5285f622669b67fbbe70f0369f9e003bd0d5164d4dca7570019dc5a4391be2cb"
    sha256 cellar: :any_skip_relocation, big_sur:        "8113ab81565a423fa6c90da55f6200d1d72f3fc846a1d4ed1581901eb52b2af2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03a1cca78c3894f43d3cde77cb8a5b401886a8ac3a0d5f6daef91ffaf8d4abc7"
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
