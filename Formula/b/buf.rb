class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https://github.com/bufbuild/buf"
  url "https://github.com/bufbuild/buf/archive/refs/tags/v1.37.0.tar.gz"
  sha256 "08b175e3a139ea9f3664650be612089a7e120761ce7e6e1b2f738ff9ed9befd1"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e54a870aaf4d5e97ccce5f01368c2e25a0e1d471b581ef722795c628c60761c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e54a870aaf4d5e97ccce5f01368c2e25a0e1d471b581ef722795c628c60761c7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e54a870aaf4d5e97ccce5f01368c2e25a0e1d471b581ef722795c628c60761c7"
    sha256 cellar: :any_skip_relocation, sonoma:         "467c3643c0817a24a6c22fb16d57f8eca241ea87d99d909c62725288061d85d4"
    sha256 cellar: :any_skip_relocation, ventura:        "467c3643c0817a24a6c22fb16d57f8eca241ea87d99d909c62725288061d85d4"
    sha256 cellar: :any_skip_relocation, monterey:       "467c3643c0817a24a6c22fb16d57f8eca241ea87d99d909c62725288061d85d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6da08d2dffd0aecb750fd33ced4ef3b7b544ed2603ba1cddeae83e5ef418e437"
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
