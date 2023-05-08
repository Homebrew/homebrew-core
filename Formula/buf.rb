class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https://github.com/bufbuild/buf"
  url "https://github.com/bufbuild/buf/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "5b7cab965af67abd581af167d00399397f8596799a72425c55d96a6e0126b361"
  license "Apache-2.0"
  head "https://github.com/bufbuild/buf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "59b4d3fd6cfc844b04948717fc58f7af55e4af718dc190361023f552d154714f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59b4d3fd6cfc844b04948717fc58f7af55e4af718dc190361023f552d154714f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7d0eabedbd1096e3e3c529ec72414dfd35b83a88db5c7035d3f445cd7d4d4dd9"
    sha256 cellar: :any_skip_relocation, ventura:        "3f4b9bd8560ca7520d1d6660cc4fe69f27ab060fbcb36ae14c4fb8b4a0a08469"
    sha256 cellar: :any_skip_relocation, monterey:       "3f4b9bd8560ca7520d1d6660cc4fe69f27ab060fbcb36ae14c4fb8b4a0a08469"
    sha256 cellar: :any_skip_relocation, big_sur:        "949f142791f5a0c439435f58ff2a811424e8b1c51be928517f4d778849b005ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a1b2d79c81f63722acaf094c24b0d8d1b13056272db1295cd71ce26d875c7af"
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
          - DEFAULT
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
