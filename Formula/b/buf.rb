class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https://github.com/bufbuild/buf"
  url "https://github.com/bufbuild/buf/archive/refs/tags/v1.61.0.tar.gz"
  sha256 "97459176763e09f55311fd99b38f097c8782d4a4abb0eb1e853092220547ecb6"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a30ad357770a0ccab763521523d70da8d33a36788f45eca2b6a7f5a4b4d41a7b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a30ad357770a0ccab763521523d70da8d33a36788f45eca2b6a7f5a4b4d41a7b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a30ad357770a0ccab763521523d70da8d33a36788f45eca2b6a7f5a4b4d41a7b"
    sha256 cellar: :any_skip_relocation, sonoma:        "43c2a93cce548c9069eb9d2b4a7c1d735044d9f4dc025de986c4be49ac5c8440"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be12ee373dcfe3b3eacc6b9e229de822e5a87f23de4e7c8147246ceecd5adb6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b1dc26fd28f4db6132fc3a5b11bee3a80a1ba96de0af1190e66ea0e9fa93cdd"
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
