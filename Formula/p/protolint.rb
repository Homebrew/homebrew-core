class Protolint < Formula
  desc "Pluggable linter and fixer to enforce Protocol Buffer style and conventions"
  homepage "https://github.com/yoheimuta/protolint"
  url "https://github.com/yoheimuta/protolint/archive/refs/tags/v0.49.7.tar.gz"
  sha256 "75e707b8b690264f740e6b6959bb80032d782ce1fdc20e1dc058c6c1c4503e11"
  license "MIT"
  head "https://github.com/yoheimuta/protolint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "02ec6329885253572601bce5e83685e5aef04db2b50d40189c8d984de30f0a4f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3b450a3332254d9d6c6c23dd4a5b602eb0305fea64278193c705aefbb037da90"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79e7316287ba5b4ffc4721b8002f98986e3c573b87936f7e4d93e6830d82ec75"
    sha256 cellar: :any_skip_relocation, sonoma:         "a12cb43e131aa1db2156ac440d0bca8d99f418621574f6522eb789c680e098fc"
    sha256 cellar: :any_skip_relocation, ventura:        "32ecc96f7063a2fd567a238c43e803a6e8ecfd1de288662c1cbd1509f5c2b266"
    sha256 cellar: :any_skip_relocation, monterey:       "a3a4746b626790ba226cf0fcb966cbcc580f142d4a9f157d95c14066acdb36da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "462a4fc0fbc15ba8fc4e66488ff4132d11a13dfbcfe2028ddb29d59ec67a1804"
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
