class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https://github.com/bufbuild/buf"
  url "https://github.com/bufbuild/buf/archive/refs/tags/v1.68.4.tar.gz"
  sha256 "85d4c64ae5a444b2c9022790d8bb2675c5ae653b547f9e75dc1a404480bd669c"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eff0f112c4bda18a09707f4bb123c9ec88c0004587bf39a1e69c04418384320f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eff0f112c4bda18a09707f4bb123c9ec88c0004587bf39a1e69c04418384320f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eff0f112c4bda18a09707f4bb123c9ec88c0004587bf39a1e69c04418384320f"
    sha256 cellar: :any_skip_relocation, sonoma:        "aef7fa7348e455882f7fbce600dbbb1444e55040a0847ada7813cc2a54c9a16d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e0ecbe81a643cfab522b346cd01155e76b60c3f5fa5119757a465fa18569448"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "469e1708471ce572b404f317d16a07a16c69acf5846c045a3fbb8fcfc16d6f28"
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
