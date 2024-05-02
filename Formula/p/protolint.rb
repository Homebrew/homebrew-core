class Protolint < Formula
  desc "Pluggable linter and fixer to enforce Protocol Buffer style and conventions"
  homepage "https://github.com/yoheimuta/protolint"
  url "https://github.com/yoheimuta/protolint/archive/refs/tags/v0.49.6.tar.gz"
  sha256 "a6fe1b9ac53a0081c2483876cbd461c3a48639b5c8db40ad3a3ab38692041c77"
  license "MIT"
  head "https://github.com/yoheimuta/protolint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7b7d6a4084684976a3654ae2cb41a18981cb7923dfcdeea10709c31cf000ad1c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f5115abf1df01d0d5b52f440df6626425546816bd2e4b9d195b3d556607eb41c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ef918807c5b902df9ea6a7ae0c110d63e8ffb145bd054fc3f345c156e62e70d"
    sha256 cellar: :any_skip_relocation, sonoma:         "601f6ead6a2f3923f7a6f82c7d830806744b932c709fb99772a84fec7d026875"
    sha256 cellar: :any_skip_relocation, ventura:        "0920d24efdc8ec0b9f17e3f5d430de53253d7be3e6e5af6e6be754ebf1f7ca52"
    sha256 cellar: :any_skip_relocation, monterey:       "97e95d81afc989bd33665e92f01fcc09b11f64a42dc8994b776d7a54906f3002"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0eaa6f54f21daefbe8aeaedc023243c9aaffc52ee0931745c79dcf8b3def9ed4"
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
