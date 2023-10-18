class Protolint < Formula
  desc "Pluggable linter and fixer to enforce Protocol Buffer style and conventions"
  homepage "https://github.com/yoheimuta/protolint"
  url "https://github.com/yoheimuta/protolint.git",
      tag:      "v0.46.2",
      revision: "e3594143cdab3a379479c271d025bac434e520be"
  license "MIT"
  head "https://github.com/yoheimuta/protolint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "04111d84f19e34145b9e9e7d8505b45d8c7aeb427681940ebae3971da133601f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e0d5f31044829171ad229917f3ff9ad92f91755586c408d1d69c1aed597aa9e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e25ad472469b7ea9ad9c51a058b4d490e4ee7bfc17cb5e49de099d05b6a9ee2"
    sha256 cellar: :any_skip_relocation, sonoma:         "4338a975c6bc5434e153a3e42489060dc5d55e1873ac83b5ccffeb901d0743de"
    sha256 cellar: :any_skip_relocation, ventura:        "65f35478443e068e77303d623059e98b9ae8e40b56af0468288c073793d2144f"
    sha256 cellar: :any_skip_relocation, monterey:       "1a1b1cb79b8e0991deece425edeff56e7c1dea8e30dcbb6ec40bd638b12a2cc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da37b6d4aa152aba37a502302212328825df00e3bd5532e1c17c9472c6be96ef"
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
