class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https://github.com/bufbuild/buf"
  url "https://github.com/bufbuild/buf/archive/refs/tags/v1.54.0.tar.gz"
  sha256 "e64786bd2f17dc3731dd30280cf1ba24e0781300ea0f781251ce98ce13142f49"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b49a6a017dba4db9f6afe82ad272d35060fd38b85530adf4d2f85879dfdac0e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b49a6a017dba4db9f6afe82ad272d35060fd38b85530adf4d2f85879dfdac0e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9b49a6a017dba4db9f6afe82ad272d35060fd38b85530adf4d2f85879dfdac0e"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c0908117e694085d6800479432366e88b7c56d2f7f056906dc25d6cb8e6de54"
    sha256 cellar: :any_skip_relocation, ventura:       "8c0908117e694085d6800479432366e88b7c56d2f7f056906dc25d6cb8e6de54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a5d872ca116f3c62602eb1d2e6eef3f10814cb2c70c386724b2398e146df6e8"
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
