class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https://github.com/bufbuild/buf"
  url "https://github.com/bufbuild/buf/archive/refs/tags/v1.15.1.tar.gz"
  sha256 "b41e98ee5e2beecf21a90c657acdfc7a86cec3e5a60a333984ecb9184f9f5fec"
  license "Apache-2.0"
  head "https://github.com/bufbuild/buf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ba94b63efb3e5f44dcd2984a49d33e35382195a9a7c724c8d921a9b80405b49"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ba94b63efb3e5f44dcd2984a49d33e35382195a9a7c724c8d921a9b80405b49"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ae43b6a1d09a20874aef24faea85eb9ef4c07bf2bc153e742a2d7d1adcfdcd41"
    sha256 cellar: :any_skip_relocation, ventura:        "f9ed16ac2f14eeab6eb6a73d9eefa388c3e75e80e2865ea17e889187346c9487"
    sha256 cellar: :any_skip_relocation, monterey:       "6faaf1f593bee70a45f8aad10b6f32b28fee7b98b63cd71d5df18be47037440e"
    sha256 cellar: :any_skip_relocation, big_sur:        "f9ed16ac2f14eeab6eb6a73d9eefa388c3e75e80e2865ea17e889187346c9487"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ff8f7ef636d74b01e8f16d8afe4216c0f97dc970b3daf8998d5ee6a07952be6"
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
    (testpath/"invalidFileName.proto").write <<~EOS
      syntax = "proto3";
      package examplepb;
    EOS

    (testpath/"buf.yaml").write <<~EOS
      version: v1
      name: buf.build/bufbuild/buf
      lint:
        use:
          - DEFAULT
          - UNARY_RPC
      breaking:
        use:
          - FILE
        ignore_unstable_packages: true
    EOS

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
