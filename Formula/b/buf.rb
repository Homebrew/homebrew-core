class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https://github.com/bufbuild/buf"
  url "https://github.com/bufbuild/buf/archive/refs/tags/v1.31.0.tar.gz"
  sha256 "aa10b731ce0e8b0c51b1fca511d12183f578921cbe78f424b03854e5b3ed82ed"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ae32731df3b108cbb2920bb006b19dd91e5bee4fcdb6356287625a7654c25605"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7931a5e04e0deb8f4bc37b705d77e3e325da051dd53d402e81ed5c6ec9a8ffe4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d01ccc3aa2b85f465b940909aec794ac5eb9ee923b2465503df4c02d65ca9c7"
    sha256 cellar: :any_skip_relocation, sonoma:         "1fd0d59db2c0695a07346e3417b4085f9640862ae75394518b762933f3ea6e44"
    sha256 cellar: :any_skip_relocation, ventura:        "2cbac330ecf854612989e28105567156a1eb8d7f26f326c100fcfaaf8e89ca2e"
    sha256 cellar: :any_skip_relocation, monterey:       "f1f82a8445d5b5aa2c04b6d5d826e3a235e57127ec0b29628562c573839f874a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45113ebc548932c4e192b1bad8eb616bb1fde6b9ec185a8962afb33f37051c70"
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
