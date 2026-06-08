class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https://github.com/bufbuild/buf"
  url "https://github.com/bufbuild/buf/archive/refs/tags/v1.70.0.tar.gz"
  sha256 "7da0f12d42d00a4a4fabf89af37e2e02ad5958bc7e977a713e4bc01b2a232899"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "93edd7465de3144a54333cd55d62b452e222d674c24a88efbd11bbdfb0c7da6d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93edd7465de3144a54333cd55d62b452e222d674c24a88efbd11bbdfb0c7da6d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93edd7465de3144a54333cd55d62b452e222d674c24a88efbd11bbdfb0c7da6d"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc85de8d292cbce798820192dccf86b30aecaf9a9ee6d8bbba3399a92df335ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "46ae1bb31f1e6ada969f266c4ffe85a7d007e1813f6d6db3da768c63b66f119b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18d335f2124629d10ad34563545d3511d219938a05e5295598877c9fe92ef457"
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
