class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https://github.com/bufbuild/buf"
  url "https://github.com/bufbuild/buf/archive/refs/tags/v1.63.0.tar.gz"
  sha256 "abc1e391080a539be1f6bbeed2c686956a132dda4b63122dc4e6ef0e9c6c84dc"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6418cbd7696c8d1b17b38a4231eb5197acea5c0785ec9447e33a85cd5ff38fe8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6418cbd7696c8d1b17b38a4231eb5197acea5c0785ec9447e33a85cd5ff38fe8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6418cbd7696c8d1b17b38a4231eb5197acea5c0785ec9447e33a85cd5ff38fe8"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce51b36bc6d61b9795628b81b74c5fd2c314e477bedc584194dc61319ba28b81"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd15742d0885f261171d31fe800f8f63df25adf37c56d92547307f712570f5dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88afedeec816ad394a8ea847ff2a1a63dd9902ccabddd85b2ef5c6cd3be8fd0f"
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
