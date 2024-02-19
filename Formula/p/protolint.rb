class Protolint < Formula
  desc "Pluggable linter and fixer to enforce Protocol Buffer style and conventions"
  homepage "https://github.com/yoheimuta/protolint"
  url "https://github.com/yoheimuta/protolint/archive/refs/tags/v0.47.5.tar.gz"
  sha256 "958a5852dfb90cfdb8fab2af1764818098278edcc9a967e560aa2811d8c57ce1"
  license "MIT"
  head "https://github.com/yoheimuta/protolint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bc192e44ff144c5e5a4e8f462cb1799f133b811a544ce261fc9251dbd644e3b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "18da44cd14f379fe1453c357da49b83b2efdc357fd25b65a4890febd2a7e48c9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6854923563a708a06724e94cbcd28d63ed1707d1ece098c16c1c2a2ccabc132d"
    sha256 cellar: :any_skip_relocation, sonoma:         "20f6e758407e1158e5890820ec7553d02395eeb553483aa6704e33b526f7233f"
    sha256 cellar: :any_skip_relocation, ventura:        "cd02e12ca8363513def851c258adfe226933e58bbf2b93eac42105062d97c72d"
    sha256 cellar: :any_skip_relocation, monterey:       "01cd2adf4ab748611a65ad1cec485e5b0b6717270f00a57130d40c0236c32fca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18f1023fa1e1507867e38f150967975a1c7f539a6aa29808295913f71e95e70b"
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
