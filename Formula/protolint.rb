class Protolint < Formula
  desc "Pluggable linter and fixer to enforce Protocol Buffer style and conventions"
  homepage "https://github.com/yoheimuta/protolint"
  url "https://github.com/yoheimuta/protolint.git",
      tag:      "v0.43.1",
      revision: "562afbf8e92f944f482298acf247de8b6bb48dff"
  license "MIT"
  head "https://github.com/yoheimuta/protolint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "576b03c32ca98c7a0b24c8c65ade79ca11b08ca5bcbd508d0a387b2ce3550803"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "576b03c32ca98c7a0b24c8c65ade79ca11b08ca5bcbd508d0a387b2ce3550803"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "576b03c32ca98c7a0b24c8c65ade79ca11b08ca5bcbd508d0a387b2ce3550803"
    sha256 cellar: :any_skip_relocation, ventura:        "8c89f38201c7e696eb19818bba43d925f525dc95de61291be2a756d0f7366618"
    sha256 cellar: :any_skip_relocation, monterey:       "8c89f38201c7e696eb19818bba43d925f525dc95de61291be2a756d0f7366618"
    sha256 cellar: :any_skip_relocation, big_sur:        "8c89f38201c7e696eb19818bba43d925f525dc95de61291be2a756d0f7366618"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36703648567b586ab84af690a5ff7f0780b1b9cab1e3e19fef6575c8e7da50f5"
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
