class Protolint < Formula
  desc "Pluggable linter and fixer to enforce Protocol Buffer style and conventions"
  homepage "https://github.com/yoheimuta/protolint"
  url "https://github.com/yoheimuta/protolint/archive/refs/tags/v0.52.0.tar.gz"
  sha256 "4a5d866a9d64ce36ce08df2c2352230c3e831e9695c3bdd76933fcc199b68529"
  license "MIT"
  head "https://github.com/yoheimuta/protolint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e492da997bb2043224e77682d1b48ebc460c1817b532b052f3b0c074215bc795"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e492da997bb2043224e77682d1b48ebc460c1817b532b052f3b0c074215bc795"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e492da997bb2043224e77682d1b48ebc460c1817b532b052f3b0c074215bc795"
    sha256 cellar: :any_skip_relocation, sonoma:        "e259a2c49f15fe8498371a346bcfdad697f511f5525d4099bd6b8be79da0d59b"
    sha256 cellar: :any_skip_relocation, ventura:       "e259a2c49f15fe8498371a346bcfdad697f511f5525d4099bd6b8be79da0d59b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a33c71602e367cb4eb66a8f0d6871968d441bc3a514e48dc3843cd7efece856c"
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
