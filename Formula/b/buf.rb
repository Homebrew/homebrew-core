class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https://github.com/bufbuild/buf"
  url "https://github.com/bufbuild/buf/archive/refs/tags/v1.58.0.tar.gz"
  sha256 "29cf530f559ea1f683b3aa6a32c8531a20d0918cc626e16638a8a709f1749000"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2e1aa0b6485a6b235921356df37230d43b59ad6a54286911a708c657bb6f6b67"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e1aa0b6485a6b235921356df37230d43b59ad6a54286911a708c657bb6f6b67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e1aa0b6485a6b235921356df37230d43b59ad6a54286911a708c657bb6f6b67"
    sha256 cellar: :any_skip_relocation, sonoma:        "54b1584b1f4301c10a5d7448a3df66ba5d4a3524eca6bd44a151f9b52ebb705f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04fe24efa9218dda64e16db8661126d271dabe0cd374b0893112e23839df5dca"
  end

  depends_on "go" => :build

  def install
    %w[buf protoc-gen-buf-breaking protoc-gen-buf-lint].each do |name|
      system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/name), "./cmd/#{name}"
    end

    generate_completions_from_executable(bin/"buf", "completion")
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
