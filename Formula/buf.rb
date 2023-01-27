class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https://github.com/bufbuild/buf"
  url "https://github.com/bufbuild/buf/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "7568666bd4f145443af828745b38f290fb28068735184ec6614e93beb7c09c7d"
  license "Apache-2.0"
  head "https://github.com/bufbuild/buf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "08eca4dc90f5d430c923960a6f305f07230f496c8b2522529f735ab2f9d188c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7abba8bd01a4c65a0a915ed8068178d6140e990bfe2629fcca0d750d0139d9c9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f0a7e51fb8327173623ba7acef1131b434c8d7a13bc3d5212d623566bb4e91fc"
    sha256 cellar: :any_skip_relocation, ventura:        "f92c3fa24a7689ec8de5f64cd5e8d12ce8237c8b9b5b8f7dd20f84f68900f301"
    sha256 cellar: :any_skip_relocation, monterey:       "88959cd7e70d73d6e3cd5ef853bd933a79fcf860876c13a57b73c8a5f092bbf4"
    sha256 cellar: :any_skip_relocation, big_sur:        "26acfbd3afbbdc5ec449e353e496f1ddec7a40f4fd40744bbf7b93427e1d41f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1770de860f29dea5cfa60f66cb94445864dcccb1967042d5ce5b7d50539936a0"
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
