class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https://github.com/bufbuild/buf"
  url "https://github.com/bufbuild/buf/archive/refs/tags/v1.65.0.tar.gz"
  sha256 "386b49aaa2d763fa5d73ff2eb7e88fff89c6b1feacdc6b5e1badc1a173d79fbf"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8fc74562f26a7c601592c1a5a15201613f4684aabf8e4be8a80ef0e3d98a7851"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8fc74562f26a7c601592c1a5a15201613f4684aabf8e4be8a80ef0e3d98a7851"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8fc74562f26a7c601592c1a5a15201613f4684aabf8e4be8a80ef0e3d98a7851"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e5607470f164334ca1da2ec8fbb11c7ba02fd4763f2b031cce60927203aa3b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd5fce17eeb0d24d273642513ab075ecd56176b09734c32f54a705f9587e1354"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce34d267fd384601404ee908825cb34f9060da7c939be10f1b1c8a26839e9f15"
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
