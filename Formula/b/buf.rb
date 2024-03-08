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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d411d52c9cd26424ae25da2e227d74ffd1973d9640af9d9eb41de57d4e1c6de4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "135335f7bbf282b898e0fab326e3d9697a642475cf011af6200aa7c2c255017b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f4f09cec84aee2ac1bb239302c12ec23a8db43f6368eaa27b2a4384a346b879"
    sha256 cellar: :any_skip_relocation, sonoma:         "bcbc22ee38336463b0a081ca2f4508c9324274eed8b5a16f99b1ac8b5a2e6839"
    sha256 cellar: :any_skip_relocation, ventura:        "602ee9045c5080c488892bbd91a6b11020dadba80d42adc3cbfffb0b3b1726a8"
    sha256 cellar: :any_skip_relocation, monterey:       "1c0a3cca6000378496b7d7cb84959d0ee7d08d765c4f6fdb1f9da460d8752e7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e66c4782d8a011f17c1e386a80d934b410b05fdba7851075e8993738108ce668"
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
