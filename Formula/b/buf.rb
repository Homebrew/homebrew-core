class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https://github.com/bufbuild/buf"
  url "https://github.com/bufbuild/buf/archive/refs/tags/v1.64.0.tar.gz"
  sha256 "e485494488ddae5fd0bdc8d7ee8e5b5cc6c266a50db1823d6e92d729dee05275"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ef567aab7e0ffece13827669a5a4e3e5bf160625410e9c6db932c613368d5fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ef567aab7e0ffece13827669a5a4e3e5bf160625410e9c6db932c613368d5fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ef567aab7e0ffece13827669a5a4e3e5bf160625410e9c6db932c613368d5fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "009efcf279fdedf603cc666ebdf8b6f65b2e373cd13eff49119348cd99b00dd8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a954d2c045690478199aeba6403043c1b029a2b2a0c3948cf558739e36f70b1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da5e82a136bf68f5c4815b3b11138368ade11cc91555af6948aeef4b8fdbd60e"
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
