class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https://github.com/bufbuild/buf"
  url "https://github.com/bufbuild/buf/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "b7cc774fb13758500de5d0c5f74b09cf3f6e5597420b7c762e01ed195e102a2d"
  license "Apache-2.0"
  head "https://github.com/bufbuild/buf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c73ebe78d66871527cdc42fa6c608f6fe1221df5c61bd3c6f154155b97f03882"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "82032b4464756ae53cc016a4fdff5f78dde856a19eb9200635b6a8339406ac61"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "63b2d9f0753da37a895c0fd9a9f75f433661f719845cd1a71315b7efd6214b56"
    sha256 cellar: :any_skip_relocation, ventura:        "fb0f73236cb419bfba2880bc861ddbc593c4361a35b1c0a6455c66576dbdf884"
    sha256 cellar: :any_skip_relocation, monterey:       "d5c43fe4ec150bb88046bb35f6af71726e502bd20f2b6b7259a644cafa561e61"
    sha256 cellar: :any_skip_relocation, big_sur:        "829a3b1a85ecaace5cb9d0fee54b2b068ddecbf17db19c6dc949aaf498800d8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6efa3cb37df477eb7f3ce1aa41592a4e4199e7891bc353092f53c034828829c"
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
