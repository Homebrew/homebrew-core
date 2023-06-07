class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https://github.com/bufbuild/buf"
  url "https://github.com/bufbuild/buf/archive/refs/tags/v1.21.0.tar.gz"
  sha256 "daf5b663960ece9a0d042ad715a1134ac54b8d3963b479787b275fbf27810f6b"
  license "Apache-2.0"
  head "https://github.com/bufbuild/buf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "551333534092d57e75156eda8bfe19347816a8d63ebabee6dbc87ef0cf7a0659"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "597a01c3c009334b280bf7fc99af7dff4b1f803b0a422658eafed7dfe2ac79d8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "597a01c3c009334b280bf7fc99af7dff4b1f803b0a422658eafed7dfe2ac79d8"
    sha256 cellar: :any_skip_relocation, ventura:        "91fbdce026f6d2723f2c861cdb93018df530002be674c15f93d4ba2437c936b9"
    sha256 cellar: :any_skip_relocation, monterey:       "367df026ca211ff7e5ff64bea92c218712a393303c970cb2d1305cbdf90ca582"
    sha256 cellar: :any_skip_relocation, big_sur:        "367df026ca211ff7e5ff64bea92c218712a393303c970cb2d1305cbdf90ca582"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9e71ff6ab7f03ab7a327e56fec01f63f5a713479fb1dd83e521063cccf1fcf5"
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
