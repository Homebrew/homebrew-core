class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https://github.com/bufbuild/buf"
  url "https://github.com/bufbuild/buf/archive/refs/tags/v1.27.1.tar.gz"
  sha256 "ffe3f817527c3c92e26f88d85b8abf2f414071074e30ef2f7597e3e9dc69492c"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6ffec83b2738a6739e8f852585c488ad446b142f62601f84173a798e62582992"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fbcef83d467951531a3ea1de376cd78e919490ea0ed410a7d0b73fb262d90782"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bed4ebe1d4dc742b63a40c2900d6e2271c6eebd9cd1c648f5b78860f779f4ee8"
    sha256 cellar: :any_skip_relocation, sonoma:         "90dff94a8e996411fa8ea46aea716259b7367db303eff9b23973b998d2e5aac7"
    sha256 cellar: :any_skip_relocation, ventura:        "eef5a7a042318f0547dbf18338c63f185fa0c99619082261a28099c0e6ea6ec2"
    sha256 cellar: :any_skip_relocation, monterey:       "d8f9fbaeeec5d7940ba5b798515c28db5d590d1cd527e9212aa571045f7aa9ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "379c70913b39fdd2878232f64ed29dc8ce9382ad913be0642bb34494a2870dd5"
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
