class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.49.0.tar.gz"
  sha256 "5660309b542aef018eb77b6831bc4ee80f6d35137c900e77f3b488b6bf75c8bc"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c1b270bf58c5acc7221ace9b00fadd34393b9fda4a836791d53ff91dcd0310b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1b270bf58c5acc7221ace9b00fadd34393b9fda4a836791d53ff91dcd0310b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1b270bf58c5acc7221ace9b00fadd34393b9fda4a836791d53ff91dcd0310b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "10554cbfc534bae2cc2cab9a9f7a99e6b0cd3b3cbfa5a44a2c9c468603208be4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c5c5d2ee2b6c00408cfbd1bf008dc41d6e7804aa33b670a12d6fcabab811185"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6dccc1354e9c0dcaa3fa188d89211e1e67102d415049dcf8df47d2fae58d959f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/hangxie/parquet-tools/cmd/version.version=v#{version}
      -X github.com/hangxie/parquet-tools/cmd/version.build=#{time.iso8601}
      -X github.com/hangxie/parquet-tools/cmd/version.source=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"parquet-tools")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/parquet-tools version")

    resource("test-parquet") do
      url "https://github.com/hangxie/parquet-tools/raw/950d21759ff3bd398d2432d10243e1bace3502c5/testdata/good.parquet"
      sha256 "daf5090fbc5523cf06df8896cf298dd5e53c058457e34766407cb6bff7522ba5"
    end

    resource("test-parquet").stage testpath

    output = shell_output("#{bin}/parquet-tools schema #{testpath}/good.parquet")
    assert_match "name=parquet_go_root", output
  end
end
