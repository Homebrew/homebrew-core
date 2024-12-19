class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https://github.com/bufbuild/buf"
  url "https://github.com/bufbuild/buf/archive/refs/tags/v1.48.0.tar.gz"
  sha256 "cff797352d237e69dd04372fb284e1162eb65db812e8de86946968418a146221"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c38479740c9ab49763bd9ae485bfce44afda6b4ea3dc3ca0b3ff5b783580b2ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c38479740c9ab49763bd9ae485bfce44afda6b4ea3dc3ca0b3ff5b783580b2ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c38479740c9ab49763bd9ae485bfce44afda6b4ea3dc3ca0b3ff5b783580b2ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "443861a1711a686e133eb6f4a5b7e22a8f8648359e3e231f9d5067313cd821bc"
    sha256 cellar: :any_skip_relocation, ventura:       "443861a1711a686e133eb6f4a5b7e22a8f8648359e3e231f9d5067313cd821bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "661392863a24c8cdb6b7a831326eed9de610219386020c05f2e1463822f0df30"
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
