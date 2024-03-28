class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https://github.com/bufbuild/buf"
  url "https://github.com/bufbuild/buf/archive/refs/tags/v1.30.0.tar.gz"
  sha256 "a67192bd6fc001a8e764040bf6eced5ffb93fcfa513d546f43a9016d5aae4a5a"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b7a89b64ab4fd52f8f0a1ba4869e1a4b4f134ecd111f153db9d7493a9b673c66"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d5ad34a975f8c8ed0e7e0d5982918dcdc361f8780939b1408e3b510e23eb617"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2cdbff36d5fac1849be16e23b4c70090319ae8026275b13ecb168aa9c23ce113"
    sha256 cellar: :any_skip_relocation, sonoma:         "5f6f49b38714cc125ee2633d3682f4890c2d296ff808349cde0b0e761e51a62a"
    sha256 cellar: :any_skip_relocation, ventura:        "606296fdd6c0c9a165ba9293cb8eb1cab13f4b8ac13f9644d232400343351b14"
    sha256 cellar: :any_skip_relocation, monterey:       "2b779c8ae66653c4e311cebbdcd63f8223379283aad80455206fad67638a27bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f938936de7c2223e0967314f86a2b32564a5f25d13ab21bd1875eb6903d2f73"
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
