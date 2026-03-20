class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https://github.com/bufbuild/buf"
  url "https://github.com/bufbuild/buf/archive/refs/tags/v1.66.1.tar.gz"
  sha256 "5e20cb1090244d81057bcea44b03acca845579f751753cec1dce8b9d08af5cba"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "822978826d3901846b21bb36021172e5b164d5f954ad92d7fbc13643b228cf55"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "822978826d3901846b21bb36021172e5b164d5f954ad92d7fbc13643b228cf55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "822978826d3901846b21bb36021172e5b164d5f954ad92d7fbc13643b228cf55"
    sha256 cellar: :any_skip_relocation, sonoma:        "4eb96b51aa844a5a7435c31a2453a18bdbe7f5cb78018d3b2c2a1a74132e7b39"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "deb4bfac6b384c5bf1fbf9f8fa00d07abf4b6927e27e58e5cc4ec125e776c687"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5b8bc98055de8bf035708b8d6fba58fc566f44fa4257a56d542ecc11554d28e"
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
