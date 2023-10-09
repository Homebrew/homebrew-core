class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https://github.com/bufbuild/buf"
  url "https://github.com/bufbuild/buf/archive/refs/tags/v1.27.0.tar.gz"
  sha256 "2a4ddbf3eeb914a88b732af6eefc80098febfa7537097fc2a507899361e37fc0"
  license "Apache-2.0"
  head "https://github.com/bufbuild/buf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eb38dfbe6467ff98d0148e2f6d10f9005553d1ecf779237336768cee99fd20b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "52adb70403f85a9cc74f283ab751e2d09d478ee85b7ddaa86a1529c305d9cf0b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0bab5632feb8b4cece925192d7c83ed9fe7a617212fd5bb1bb4546d26a8959d0"
    sha256 cellar: :any_skip_relocation, sonoma:         "2f0972d44cc50c3a1bce99e31b301ba40f931f13299f7e069f5bd7c469d6de65"
    sha256 cellar: :any_skip_relocation, ventura:        "2851853fa898b9d40b04476c83745933580e47be0562cab819f917afa74cc93c"
    sha256 cellar: :any_skip_relocation, monterey:       "3145ede5ff159d9bf41a0a52782523b4df10feff506a110180afb28346e71824"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9de87c2559072169f975ef13cbfa7da71baf61ffe311488e19b89944b98f6a83"
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
