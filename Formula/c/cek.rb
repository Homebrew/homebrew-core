class Cek < Formula
  desc "Explore the (overlay) filesystem and layers of OCI container images"
  homepage "https://github.com/bschaatsbergen/cek"
  url "https://github.com/bschaatsbergen/cek/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "df2e264e15b7e5d2d72146090300ad6833801213e552a55c9079449d8b8a71d8"
  license "MIT"
  head "https://github.com/bschaatsbergen/cek.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ec560a594f53c1039bb8718a61e3ad197d381053ddff378156e10f073cc687a2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ec560a594f53c1039bb8718a61e3ad197d381053ddff378156e10f073cc687a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ec560a594f53c1039bb8718a61e3ad197d381053ddff378156e10f073cc687a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "348d0f4fce928c9fd1ec0d109fce2ccec191b979125097e679b3a0cd47790da4"
    sha256 cellar: :any,                 x86_64_linux:      "6823661b656fb14477b8f26b10ff69c9d6e6d2675b600df1d3106dc2e339c91c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-X github.com/bschaatsbergen/cek/version.Version=#{version}]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_includes shell_output("#{bin}/cek version"), "cek version #{version}"
    assert_match "localhost", shell_output("#{bin}/cek cat alpine:latest /etc/hostname")
  end
end
