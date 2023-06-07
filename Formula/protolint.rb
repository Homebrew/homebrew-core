class Protolint < Formula
  desc "Pluggable linter and fixer to enforce Protocol Buffer style and conventions"
  homepage "https://github.com/yoheimuta/protolint"
  url "https://github.com/yoheimuta/protolint.git",
      tag:      "v0.44.0",
      revision: "b0ef834b9654ce29d56098ff3a253fa1cf79e451"
  license "MIT"
  head "https://github.com/yoheimuta/protolint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4edf71927eb7eac004fdcd6a02e73ffed0a682afb18588b2c6e443e10c77f45"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4edf71927eb7eac004fdcd6a02e73ffed0a682afb18588b2c6e443e10c77f45"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b4edf71927eb7eac004fdcd6a02e73ffed0a682afb18588b2c6e443e10c77f45"
    sha256 cellar: :any_skip_relocation, ventura:        "322a0dbf094db56cd0c049edee878a71cae9884e4da206a49af5dea610aee74e"
    sha256 cellar: :any_skip_relocation, monterey:       "322a0dbf094db56cd0c049edee878a71cae9884e4da206a49af5dea610aee74e"
    sha256 cellar: :any_skip_relocation, big_sur:        "322a0dbf094db56cd0c049edee878a71cae9884e4da206a49af5dea610aee74e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34bbb55c455e4a2470b0a6eca71a40b2ebbf3fd4545005986d3fa81aeb63c940"
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
