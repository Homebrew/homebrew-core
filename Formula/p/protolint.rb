class Protolint < Formula
  desc "Pluggable linter and fixer to enforce Protocol Buffer style and conventions"
  homepage "https://github.com/yoheimuta/protolint"
  url "https://github.com/yoheimuta/protolint/archive/refs/tags/v0.50.5.tar.gz"
  sha256 "1be01df54565c4831db8f1dcef38347e25a7a945d9f3ff77ca7a488e0307b3ac"
  license "MIT"
  head "https://github.com/yoheimuta/protolint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "47bd82f835efaf0be33ac176ccca3e89cdf14dff10d4a1b5ef842714ce0a55c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "acfe481beda6d90e195f02e5b41a56f245e43328e47235f640466dec00b9308a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "632eab480ace5de4f28e7cf7ad38f708bf0983e9d5cbc08daab0c0192fe0d475"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d779bba6728cb9412d0c1ac33081ef04751d9ab08ada4cdbdea71e29a9f4ff2a"
    sha256 cellar: :any_skip_relocation, sonoma:         "aca0db3bd73a04b3f5ff010690c7931a14cd66d7f341752be61bf971d7549416"
    sha256 cellar: :any_skip_relocation, ventura:        "3b3fbb150f433d148fd5082aff4e00471cbdd46c2ea07897fadbdc1a30f1c418"
    sha256 cellar: :any_skip_relocation, monterey:       "11b1f8dd832644c3b25e8e242de8f308249c0f34f0c843162cbfe9b68efadfbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "966703624ba742d00d45935791289d66277e7742c43534321cd576dda2a09925"
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
