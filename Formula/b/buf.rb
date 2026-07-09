class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https://buf.build"
  url "https://github.com/bufbuild/buf/archive/refs/tags/v1.71.0.tar.gz"
  sha256 "fad7621cfcf54891a7b1c82c060b7a54c2ad6d13e0a1c99aea2d744e43bc82b7"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2e874c8c448ae4b67cfc0f853cc5b51bd3b229be1f6a2697b4a6d8d86e1d4797"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e874c8c448ae4b67cfc0f853cc5b51bd3b229be1f6a2697b4a6d8d86e1d4797"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e874c8c448ae4b67cfc0f853cc5b51bd3b229be1f6a2697b4a6d8d86e1d4797"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6dfbcf3c18cef408880fa9700cc136613e957507ea61109012a167f56a2dda4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "157aacbaf87422deb9165c19064a6b39ef0ca5f392ae5ab7ffcf6db7337f5f36"
    sha256 cellar: :any,                 x86_64_linux:  "d4e5dac752f627898e748b51ec08b84137c85923cd634bbad17fdf7576c8d5d1"
  end

  depends_on "go" => :build

  def install
    %w[buf protoc-gen-buf-breaking protoc-gen-buf-lint].each do |name|
      system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/name), "./cmd/#{name}"
    end

    generate_completions_from_executable(bin/"buf", shell_parameter_format: :cobra)
    man1.mkpath
    system bin/"buf", "manpages", man1
  end

  test do
    (testpath/"invalidFileName.proto").write <<~PROTO
      syntax = "proto3";
      package examplepb;
    PROTO

    (testpath/"buf.yaml").write <<~YAML
      version: v1
      name: buf.build/bufbuild/buf
      lint:
        use:
          - STANDARD
          - UNARY_RPC
      breaking:
        use:
          - FILE
        ignore_unstable_packages: true
    YAML

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
