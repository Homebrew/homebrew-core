class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https://buf.build"
  url "https://github.com/bufbuild/buf/archive/refs/tags/v1.75.0.tar.gz"
  sha256 "e1b688283938b19ff072789d37f371e9bdfbc866ebb719b20c1f1bdc4a9ca8ff"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/bufbuild/buf.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "26ef8718b2394cab46f67eb88be5f0ee7084e1af79a0f9d2fc6ea2c9193a0d99"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "26ef8718b2394cab46f67eb88be5f0ee7084e1af79a0f9d2fc6ea2c9193a0d99"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "26ef8718b2394cab46f67eb88be5f0ee7084e1af79a0f9d2fc6ea2c9193a0d99"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f522aefcbc0810caadbd88d89cf07093e0a4f07901b0b5f2f7c7fc5770f0cd92"
    sha256 cellar: :any,                 x86_64_linux:      "0e7ef4b67ed02fb4ecc5f26877173106a95ea61aeba8fc64c83c47f2bf3c4991"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    %w[buf protoc-gen-buf-breaking protoc-gen-buf-lint].each do |name|
      system "go", "build", *std_go_args(output: bin/name), "./cmd/#{name}"
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
