class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https://github.com/bufbuild/buf"
  url "https://github.com/bufbuild/buf/archive/refs/tags/v1.26.1.tar.gz"
  sha256 "6e60239c6c26315e3aeac6ede9f485d39d11548293536f0c0ae06d52fc275fc7"
  license "Apache-2.0"
  head "https://github.com/bufbuild/buf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c475cd048376ee072eab0937e6d7f5d68d05b7020060935c01543ec23f5d5fdf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c475cd048376ee072eab0937e6d7f5d68d05b7020060935c01543ec23f5d5fdf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c475cd048376ee072eab0937e6d7f5d68d05b7020060935c01543ec23f5d5fdf"
    sha256 cellar: :any_skip_relocation, ventura:        "2bfa6c69743f930335e5bc9a2df3228f0afdff496843f8d1acc8962bc25d1e2e"
    sha256 cellar: :any_skip_relocation, monterey:       "2bfa6c69743f930335e5bc9a2df3228f0afdff496843f8d1acc8962bc25d1e2e"
    sha256 cellar: :any_skip_relocation, big_sur:        "2f3790702a4c5e5d67be9589f71bed2cfcb173583063df5303fceb34ad1f5069"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0931ada10907d38c1568e86a9b2bff44eeb0d591aaec45895b3b8ff45e72a81"
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
