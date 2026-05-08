class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https://github.com/bufbuild/buf"
  url "https://github.com/bufbuild/buf/archive/refs/tags/v1.69.0.tar.gz"
  sha256 "b5d662379d597a3010b9fde72d6102642d83b192b61138002a9a4a788e40806a"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c640f8f287678dc8730a27a8c7c1fb936b37c0c38b34329308fbed2a06fc2ccc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c640f8f287678dc8730a27a8c7c1fb936b37c0c38b34329308fbed2a06fc2ccc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c640f8f287678dc8730a27a8c7c1fb936b37c0c38b34329308fbed2a06fc2ccc"
    sha256 cellar: :any_skip_relocation, sonoma:        "80eff4f1e1e9bc08e3e05213b68d14a210a965de90923266ea453ed96e19f064"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e8244a13769b6661d41fb295551cb8249b89fecd4cc281614295979ea6b5274"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "095f02f59e6ad0f5603fbf7705eb4f52353f238ea60b233f056279b49a05d42a"
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
