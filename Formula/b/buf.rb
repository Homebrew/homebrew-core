class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https://github.com/bufbuild/buf"
  url "https://github.com/bufbuild/buf/archive/refs/tags/v1.45.0.tar.gz"
  sha256 "18c083b02faeb59bf504e6e462e4b6aaf1e5db5ec4dd739322fc804cda6a069b"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e51691930649859cf868448074d2a23f8f76ee5a274d305bc5faa68a72e10f74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e51691930649859cf868448074d2a23f8f76ee5a274d305bc5faa68a72e10f74"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e51691930649859cf868448074d2a23f8f76ee5a274d305bc5faa68a72e10f74"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a2dff2a5fd661e374747ca985573628ec476e97456e03f97e84570ad53d7e90"
    sha256 cellar: :any_skip_relocation, ventura:       "4a2dff2a5fd661e374747ca985573628ec476e97456e03f97e84570ad53d7e90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fb66b7fdafe01a4cd175e055fb174fbdbf3178d54405f109406aa5b2fc29864"
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
          - STANDARD
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
