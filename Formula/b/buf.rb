class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https://github.com/bufbuild/buf"
  url "https://github.com/bufbuild/buf/archive/refs/tags/v1.52.1.tar.gz"
  sha256 "08489aa993fe36ad5965381a3ff2848c8d4f3a4f76096f0fdc19355f77826253"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ccd6752ea8ff393dd77db7d5e047a24a98118328f34d7e3d6619435e96a9c5cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ccd6752ea8ff393dd77db7d5e047a24a98118328f34d7e3d6619435e96a9c5cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ccd6752ea8ff393dd77db7d5e047a24a98118328f34d7e3d6619435e96a9c5cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7b19e75451dd2f2880526bfe136e9f47afb9366dd0118c5e7f9df5c08f7a77e"
    sha256 cellar: :any_skip_relocation, ventura:       "b7b19e75451dd2f2880526bfe136e9f47afb9366dd0118c5e7f9df5c08f7a77e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fc5dcd6faf2de40bec9f1e7209a4d9c15718eb96457044d19841d122e9989f7"
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
