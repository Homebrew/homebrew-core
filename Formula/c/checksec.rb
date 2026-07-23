class Checksec < Formula
  desc "Security feature auditing for ELF binaries and Linux kernels"
  homepage "https://slimm609.github.io/checksec"
  url "https://github.com/slimm609/checksec/archive/refs/tags/3.2.0.tar.gz"
  sha256 "3ea46986821070ed06fef5215b2a83a9076115a865da70874e19f214db2c8d83"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e4dc921476d5c23ece70ee896f2252d86ca6853df595e1656711dfaf115b949"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77ea4b237ca591a62ac01107af0ef993ee692e19f479e1e29a2ce9259773c5df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e79aa346142d6cac8cc88a83fabd9fc12e0bb8d21a6659791b1afaa3e6109ccb"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0a84dbb75443267151fc2aa057e8776dc04f1a23e8bc4c545d680467b0be135"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "88931def25ef022e2f22b0f11cbb56961ca91365a734df24bfa2d6c6da3df684"
    sha256 cellar: :any,                 x86_64_linux:  "e8d523afa94f9987bbf287b41cbbbe681318e63e5a8726f51194e356d218fc33"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"checksec", shell_parameter_format: :cobra)
    man1.install "extras/man/checksec.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/checksec --version")
    assert_match "Partial RELRO", shell_output("#{bin}/checksec file #{test_fixtures("elf/hello")}")
  end
end
