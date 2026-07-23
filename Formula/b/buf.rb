class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https://buf.build"
  url "https://github.com/bufbuild/buf/archive/refs/tags/v1.72.0.tar.gz"
  sha256 "52ee072d93e17adec529ca13dd701c0939b3a210a1c2803379007c7a830f502d"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca22259d329af2a6b332994cdde5e72bbd80e8125b5e3c88aec1eaba05d05ac1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca22259d329af2a6b332994cdde5e72bbd80e8125b5e3c88aec1eaba05d05ac1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca22259d329af2a6b332994cdde5e72bbd80e8125b5e3c88aec1eaba05d05ac1"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a96bea7663eb16764c6d272fb98e9d9aa1d6e131fa2693c559dab0efd4c8e63"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d247ba475e5bf8ec9833a8cf81ec002fc48181936f76aa41396987e9fe39277"
    sha256 cellar: :any,                 x86_64_linux:  "6ad4d9ad1c626925ab03d09eed884bb2fe481992ede40c9ec406162f539ac6a5"
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
