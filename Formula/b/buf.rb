class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https://github.com/bufbuild/buf"
  url "https://github.com/bufbuild/buf/archive/refs/tags/v1.60.0.tar.gz"
  sha256 "2e536431c669b238ee575c66cc229fc8ce94632dd29dea0b7964c9a023444ce8"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af66576fc622673fa0f45450b606df4af36711255158d2d0a474421d4890a657"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af66576fc622673fa0f45450b606df4af36711255158d2d0a474421d4890a657"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af66576fc622673fa0f45450b606df4af36711255158d2d0a474421d4890a657"
    sha256 cellar: :any_skip_relocation, sonoma:        "e955744498c27f76425b487241ccaaabe221a530e321bb61d79cccf4360849c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fcd0413b44bb97f161c0199f571e68380fbf1a2566b13f2ffe5bbad4b2b701e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d21be0a52b2727b19ece6c03c3939772756a8acc89d2c04524ee5de4282bd7f0"
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
