class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https://buf.build"
  url "https://github.com/bufbuild/buf/archive/refs/tags/v1.74.0.tar.gz"
  sha256 "09f5e4f103ff418bbce2f98ea342852b590f45357c8f3492e827a5976cb9075c"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f1367bfab3c7e6b906a835ed6e480cbcd4e30592582ffbc60cdb1af30c02271d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f1367bfab3c7e6b906a835ed6e480cbcd4e30592582ffbc60cdb1af30c02271d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f1367bfab3c7e6b906a835ed6e480cbcd4e30592582ffbc60cdb1af30c02271d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9ab85b71c74c58d7e0584abb6b69027a78b8bb147891979f26da38ec1079ed1f"
    sha256 cellar: :any,                 x86_64_linux:      "f75d16552f03f36e57aa8c6181a332eb2ca2f77261453dbf0ba9db8a920c8c00"
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
