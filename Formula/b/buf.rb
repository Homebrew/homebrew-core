class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https://github.com/bufbuild/buf"
  url "https://github.com/bufbuild/buf/archive/refs/tags/v1.50.0.tar.gz"
  sha256 "8ef886f4793bc76abc91da41a2ab87666bb5bfef86ddbb95e7f8240b8978c1df"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eaf2071299740853dfbf7e46c85073f2784463441b8f4e33153068debd546592"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eaf2071299740853dfbf7e46c85073f2784463441b8f4e33153068debd546592"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eaf2071299740853dfbf7e46c85073f2784463441b8f4e33153068debd546592"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6c2d7451f860551e572cebd361132ea78bda29c1ecfde7503353b8b5d3f96a9"
    sha256 cellar: :any_skip_relocation, ventura:       "f6c2d7451f860551e572cebd361132ea78bda29c1ecfde7503353b8b5d3f96a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ddac19ee15235898410adaa697f419a813cdf61a9c769ff14cecdfd0c474fbfb"
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
