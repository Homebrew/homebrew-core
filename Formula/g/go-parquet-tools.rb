class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.58.1.tar.gz"
  sha256 "466510bc0040fdac5c29f5fc4edbf72fe3da014669974e249e5b852eaae13e9d"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3dd6d80eaba2b1004b53e606d7f29a3dc2e46cbee9418e223e7cbaf8a10f77ed"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3dd6d80eaba2b1004b53e606d7f29a3dc2e46cbee9418e223e7cbaf8a10f77ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3dd6d80eaba2b1004b53e606d7f29a3dc2e46cbee9418e223e7cbaf8a10f77ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1e72fb75438bb4ea31607734f603d833a2141a533cccd0c26558876b2e492d77"
    sha256 cellar: :any,                 x86_64_linux:      "a4f510966541c7fb7a90e39de6194cd6689dad442e79332334e21c2451c4808a"
  end

  depends_on "go" => :build

  # `test do` block downloads a test fixture resource
  resource "test-parquet", :test do
    url "https://github.com/hangxie/parquet-tools/raw/950d21759ff3bd398d2432d10243e1bace3502c5/testdata/good.parquet"
    sha256 "daf5090fbc5523cf06df8896cf298dd5e53c058457e34766407cb6bff7522ba5"
  end

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/hangxie/parquet-tools/cmd/version.version=v#{version}
      -X github.com/hangxie/parquet-tools/cmd/version.build=#{time.iso8601}
      -X github.com/hangxie/parquet-tools/cmd/version.source=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"parquet-tools")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/parquet-tools version")

    resource("test-parquet").stage testpath

    output = shell_output("#{bin}/parquet-tools schema #{testpath}/good.parquet")
    assert_match "name=parquet_go_root", output
  end
end
