class Protolint < Formula
  desc "Pluggable linter and fixer to enforce Protocol Buffer style and conventions"
  homepage "https://github.com/yoheimuta/protolint"
  url "https://github.com/yoheimuta/protolint/archive/refs/tags/v0.58.0.tar.gz"
  sha256 "7d5f4650ed23f68c34a6be1ba77fb3661dd4b7b28b64664a479b6835febceb18"
  license "MIT"
  head "https://github.com/yoheimuta/protolint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "50c67b56b137888adabb258b436b96edc4aedce2a7184fb4da4a3bd152f4b560"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "50c67b56b137888adabb258b436b96edc4aedce2a7184fb4da4a3bd152f4b560"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "50c67b56b137888adabb258b436b96edc4aedce2a7184fb4da4a3bd152f4b560"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "00082246c3369183f579e89f4fa92bed037df29f17d3c8f0cc56a68d698e7a3b"
    sha256 cellar: :any,                 x86_64_linux:      "a1d61eb911accd7cbce6f1087ca35102ff4572ddaf79c7652aa2f3ec61866196"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
