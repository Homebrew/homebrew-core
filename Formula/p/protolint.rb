class Protolint < Formula
  desc "Pluggable linter and fixer to enforce Protocol Buffer style and conventions"
  homepage "https://github.com/yoheimuta/protolint"
  url "https://github.com/yoheimuta/protolint/archive/refs/tags/v0.49.1.tar.gz"
  sha256 "e7b9aedbb2afa02477e04d1a1b9c21735287d790acae7c64a891a57405681c88"
  license "MIT"
  head "https://github.com/yoheimuta/protolint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e3ef11c267bd8c52a447ffd693e00a61e7b727cc2076211976719b3d78d3333c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f317d7cbb234b44024d93db64527e8a3c116c36960f6bbcba26beacceb747c09"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fae17b7b62ec2cf11c21a95977550866392ffc46f56d5e9c0fa04be706ae67d4"
    sha256 cellar: :any_skip_relocation, sonoma:         "818dfb8ac92485a368510bb4e200686b5e4a0b48cc03abcb739c65fbe04c9786"
    sha256 cellar: :any_skip_relocation, ventura:        "87f39cae45f61363208f2dd53e327beab686aa2c5e323a5d4e52d2b13a2dec4a"
    sha256 cellar: :any_skip_relocation, monterey:       "ab5fcd377a5029bd8629807a8540fb0a902d6849232f4af8cd25ad22f212614b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17d86cb4f9e768c3f1f34a336b3ddb8c83f63a136b8d2d955442f433e564b614"
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
