class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https://github.com/bufbuild/buf"
  url "https://github.com/bufbuild/buf/archive/refs/tags/v1.15.1.tar.gz"
  sha256 "b41e98ee5e2beecf21a90c657acdfc7a86cec3e5a60a333984ecb9184f9f5fec"
  license "Apache-2.0"
  head "https://github.com/bufbuild/buf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "775393f73a385d0a40ccc814a83ab1f1a144f1b009c1d55abc1e6e2e2d240530"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "466a0165c6139f3062dc678fad479bf48c3b66f2e48104450a8609a4cbec20fb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "466a0165c6139f3062dc678fad479bf48c3b66f2e48104450a8609a4cbec20fb"
    sha256 cellar: :any_skip_relocation, ventura:        "401be5ec0f8fe4a3e1a10f8781c4466a3208a4a194033435e66adb0411bf58f9"
    sha256 cellar: :any_skip_relocation, monterey:       "401be5ec0f8fe4a3e1a10f8781c4466a3208a4a194033435e66adb0411bf58f9"
    sha256 cellar: :any_skip_relocation, big_sur:        "cacaea36936cf736ecfcc781df502a0e9a4b8dafcf22c4a81137f0e97b8ed301"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7b41f26762e45d3c8f2ea836237a8e688c1bff2a3bab21f1d36e7a8bb409e4e"
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
