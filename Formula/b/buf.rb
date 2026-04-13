class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https://github.com/bufbuild/buf"
  url "https://github.com/bufbuild/buf/archive/refs/tags/v1.67.0.tar.gz"
  sha256 "f04bfbd2877aa4e256ab27ddafc9fda29bc9e4d0789c4110a28a38bd9576acc1"
  license "Apache-2.0"
  head "https://github.com/bufbuild/buf.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ffd50d5f7104128c6b2071736272144f51ee758d6ff5cee1ec6d40959a6f46f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ffd50d5f7104128c6b2071736272144f51ee758d6ff5cee1ec6d40959a6f46f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ffd50d5f7104128c6b2071736272144f51ee758d6ff5cee1ec6d40959a6f46f"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c12bbe182fb029a597d21698b04b87f47866a11b88d105c8e10a8ce821d1b22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c851dee7b5bc4eea9d68aecf668b4c5c85276ce51d0231bb10341b6bce4dd74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b14cd4ca5a3fa108b89928d16161c865b5d0fc2876cd76d1470cb8070250382f"
  end

  depends_on "go" => :build

  def install
    %w[buf protoc-gen-buf-breaking protoc-gen-buf-lint].each do |name|
      system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/name), "./cmd/#{name}"
    end

    generate_completions_from_executable(bin/"buf", shell_parameter_format: :cobra)
    man1.mkpath
    system bin/"buf", "manpages", man1
  end

  test do
    (testpath/"invalidFileName.proto").write <<~PROTO
      syntax = "proto3";
      package examplepb;
    PROTO

    (testpath/"buf.yaml").write <<~YAML
      version: v1
      name: buf.build/bufbuild/buf
      lint:
        use:
          - STANDARD
          - UNARY_RPC
      breaking:
        use:
          - FILE
        ignore_unstable_packages: true
    YAML

    expected = <<~EOS
      invalidFileName.proto:1:1:Filename "invalidFileName.proto" should be \
      lower_snake_case.proto, such as "invalid_file_name.proto".
      invalidFileName.proto:2:1:Files with package "examplepb" must be within \
      a directory "examplepb" relative to root but were in directory ".".
      invalidFileName.proto:2:1:Package name "examplepb" should be suffixed \
      with a correctly formed version, such as "examplepb.v1".
    EOS
    assert_equal expected, shell_output("#{bin}/buf lint invalidFileName.proto 2>&1", 100)

    assert_match version.to_s, shell_output("#{bin}/buf --version")
  end
end
