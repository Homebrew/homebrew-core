class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https://github.com/bufbuild/buf"
  url "https://github.com/bufbuild/buf/archive/refs/tags/v1.33.0.tar.gz"
  sha256 "80e31a5fac40d8547b8a6a4b1dca1eabebad8586bf667f342a6d0db5f8038c72"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b7cb84fc980651614db2f13eb340b2db35f5baf6c5a400454937130d40bd4245"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3a64dfc791b5e2a440373fb75d77621d1cb9c36e590582cafc415edf24281fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bcfbb82de6edf571df9e8c791a03573ae66260cb6f54ec0e3c3765a408805b40"
    sha256 cellar: :any_skip_relocation, sonoma:         "72a7f1101621ca69f5d5aafda8f00c58e50e54a2f1ac10b6a1de876da031fbbd"
    sha256 cellar: :any_skip_relocation, ventura:        "1eaf4515ffe8c90e83a98f97211c6cfa60f1922626a56d9c9eb392c9e0c1377f"
    sha256 cellar: :any_skip_relocation, monterey:       "64e7da50b0ae0ada1ea3b6af9bdbe7ad3d7771641b628ec607934187ad003498"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61501f91ab49e62e27d027ffecc260958eeb669602dcb0f7ae4b6c4c40e6c0a6"
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
