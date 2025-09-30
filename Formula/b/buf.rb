class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https://github.com/bufbuild/buf"
  url "https://github.com/bufbuild/buf/archive/refs/tags/v1.57.2.tar.gz"
  sha256 "a7f670f9da968d05bec42b10d29651f86396f0b002e3f3a2c1c8ab9e1cb0b9e0"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "073a75f6e7d2879ee2912ad73a5413d6e2cd529b94e4866ed33c2df3bc02e7aa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "073a75f6e7d2879ee2912ad73a5413d6e2cd529b94e4866ed33c2df3bc02e7aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "073a75f6e7d2879ee2912ad73a5413d6e2cd529b94e4866ed33c2df3bc02e7aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "82ef3c8bef352a8c8588b757743478d7ad975edb6b5fd60c78f56c413d8a5507"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a479253fc90576737d9af578c7c3933280057b606693add304e3cbc3f3a35d99"
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
