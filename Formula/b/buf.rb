class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https://github.com/bufbuild/buf"
  url "https://github.com/bufbuild/buf/archive/refs/tags/v1.55.1.tar.gz"
  sha256 "01663475792aa851d4b3af16be9ec19d808cead673f986902343beed1a0063dd"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cfcd086027d3349dcb8c45a5607b96177819198350a9220dbeea17f8cc765970"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cfcd086027d3349dcb8c45a5607b96177819198350a9220dbeea17f8cc765970"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cfcd086027d3349dcb8c45a5607b96177819198350a9220dbeea17f8cc765970"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5d6667f0ce744b3552ae5769cd9712ffc7d6e89de933ca216640bbc062eadc8"
    sha256 cellar: :any_skip_relocation, ventura:       "f5d6667f0ce744b3552ae5769cd9712ffc7d6e89de933ca216640bbc062eadc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d40e54172bf8d7ec2b690bf3eb726911277ea2c1e605a4d5f1133cd0f83e13f"
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
