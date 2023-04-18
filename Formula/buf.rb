class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https://github.com/bufbuild/buf"
  url "https://github.com/bufbuild/buf/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "4e618146ec56dc874213de8f15f472629d670c7d6dca3de3544bf046ed020c03"
  license "Apache-2.0"
  head "https://github.com/bufbuild/buf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9716f17d6a2b75958a10320d2da9e0a6f14aac17c7605bee4e0c8972c4c66847"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9716f17d6a2b75958a10320d2da9e0a6f14aac17c7605bee4e0c8972c4c66847"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9716f17d6a2b75958a10320d2da9e0a6f14aac17c7605bee4e0c8972c4c66847"
    sha256 cellar: :any_skip_relocation, ventura:        "b190b169d11d6acb1d81d9da47c1369074ee50deee237e4c544ca79731c78b6a"
    sha256 cellar: :any_skip_relocation, monterey:       "0dcd006f283090c52c8fe019de13caff0005698aca05bea1e715dafbd35230f8"
    sha256 cellar: :any_skip_relocation, big_sur:        "b190b169d11d6acb1d81d9da47c1369074ee50deee237e4c544ca79731c78b6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbfa8ec325069babed211cae8180fad84fc74d1625e95282c5dbff5445bb3051"
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
