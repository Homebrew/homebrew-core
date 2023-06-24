class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https://github.com/bufbuild/buf"
  url "https://github.com/bufbuild/buf/archive/refs/tags/v1.22.0.tar.gz"
  sha256 "cc7e5353bc7378a647727432ad51a6e612e5e72f74195983127bb9a81437f205"
  license "Apache-2.0"
  head "https://github.com/bufbuild/buf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "47a3b9aad884e6592fb696ee9631a82ec4b7a01045bf281188533fadd00a7c7a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47a3b9aad884e6592fb696ee9631a82ec4b7a01045bf281188533fadd00a7c7a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1b944610563d6d6d505e662d19bc09add1fefe05fb18b004d6a0b3fbede32977"
    sha256 cellar: :any_skip_relocation, ventura:        "b8ba6a22412e9f090a6f04659281866b285fdc72169679850c97a1e2b8ec9bac"
    sha256 cellar: :any_skip_relocation, monterey:       "60a964680588ee080ca5fe2ba05c303133f78391ad135a0334bf2fee417c1792"
    sha256 cellar: :any_skip_relocation, big_sur:        "60a964680588ee080ca5fe2ba05c303133f78391ad135a0334bf2fee417c1792"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a51848d0e27fd91b879e25166732b2e121a0020b6f85e9131cedd6c4582b7dd"
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
