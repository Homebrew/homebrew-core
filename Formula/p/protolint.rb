class Protolint < Formula
  desc "Pluggable linter and fixer to enforce Protocol Buffer style and conventions"
  homepage "https://github.com/yoheimuta/protolint"
  url "https://github.com/yoheimuta/protolint/archive/refs/tags/v0.57.0.tar.gz"
  sha256 "c6bf097168e965dd32554830a4f8a87da6ab0e8902adcf12a3507009e3686e7a"
  license "MIT"
  head "https://github.com/yoheimuta/protolint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e0559a82734f9650e758873da7961db7d6e0641b1e419b2b8bac0782b6d32a03"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0559a82734f9650e758873da7961db7d6e0641b1e419b2b8bac0782b6d32a03"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0559a82734f9650e758873da7961db7d6e0641b1e419b2b8bac0782b6d32a03"
    sha256 cellar: :any_skip_relocation, sonoma:        "06c39203942571a2443918910823661b51242edc913150696df911e48bf0fb5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f53b31df68da617b457cf1a55f703660bad17aabe6a7c5006b0dde8809134cf"
    sha256 cellar: :any,                 x86_64_linux:  "3f48e9221c8c7002332e239c4ae10ee9677dbb9792be757b2476cb17e4cf419d"
  end

  depends_on "go" => :build

  def install
    protolint_ldflags = %W[
      -X github.com/yoheimuta/protolint/internal/cmd.version=#{version}
      -X github.com/yoheimuta/protolint/internal/cmd.revision=#{tap.user}
    ]
    protocgenprotolint_ldflags = %W[
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
