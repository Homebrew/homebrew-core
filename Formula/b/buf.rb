class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https://github.com/bufbuild/buf"
  url "https://github.com/bufbuild/buf/archive/refs/tags/v1.68.3.tar.gz"
  sha256 "aee1a18a7d15739869a1a9f9d9198365049b66fbefa3a928d5f89b820414da4a"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "195145016a44a58a2851237f32efeb2dde5a411e5e4bc7962292ccbcdd489095"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "195145016a44a58a2851237f32efeb2dde5a411e5e4bc7962292ccbcdd489095"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "195145016a44a58a2851237f32efeb2dde5a411e5e4bc7962292ccbcdd489095"
    sha256 cellar: :any_skip_relocation, sonoma:        "374240f875cd8f7890627918705eb570e0b495714390291e243ae9be018f4386"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd01d00f94dc420d099b8c0fe929861e38d318b5bf959a59431996fbe62cab97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d2538506a90496d940c4cbf036db648acb676fec22f94b076ef74b843c8feab"
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
