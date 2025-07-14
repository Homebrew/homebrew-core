class Protolint < Formula
  desc "Pluggable linter and fixer to enforce Protocol Buffer style and conventions"
  homepage "https://github.com/yoheimuta/protolint"
  url "https://github.com/yoheimuta/protolint/archive/refs/tags/v0.55.6.tar.gz"
  sha256 "06b50c33b37b58e971c7d32e190556f6abb9df24f56b8ded1730e8c134e7e22a"
  license "MIT"
  head "https://github.com/yoheimuta/protolint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c37dfdc89f53c3e14baaca638db3d6760df3cbf90ee09a37cb7bebba15499231"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c37dfdc89f53c3e14baaca638db3d6760df3cbf90ee09a37cb7bebba15499231"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c37dfdc89f53c3e14baaca638db3d6760df3cbf90ee09a37cb7bebba15499231"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd489eb870b57c1adb8cce8d382085b0849c8a46d27251f1fa5d3f653f7433de"
    sha256 cellar: :any_skip_relocation, ventura:       "dd489eb870b57c1adb8cce8d382085b0849c8a46d27251f1fa5d3f653f7433de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c276f2d86e503c42bece363da64f97b71cfe7d533152fd6dc1c4e3e9a183b525"
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
