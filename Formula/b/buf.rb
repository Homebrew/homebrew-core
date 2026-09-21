class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https://buf.build"
  url "https://github.com/bufbuild/buf/archive/refs/tags/v1.73.0.tar.gz"
  sha256 "5b74e94416114ccfcef2692592150a5c8459a9cb6f94088d42341ac06c389a22"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "df04188ac60caaed0d938a0c192a6b014720e000f91a5ef9a325f92452071841"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "df04188ac60caaed0d938a0c192a6b014720e000f91a5ef9a325f92452071841"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "df04188ac60caaed0d938a0c192a6b014720e000f91a5ef9a325f92452071841"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8b079ebce6f2b387af366ea19a2462d58f5746b4d59f2b99cb8e799f874810dc"
    sha256 cellar: :any,                 x86_64_linux:      "8820ef7b124ded0b13751752af6d2c754340c9d84c3a6dac7cce112b49b3fac2"
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
