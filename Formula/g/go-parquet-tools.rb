class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.57.1.tar.gz"
  sha256 "e0f3294122e6872ab8752bd27a5a2304a1f100afa4d18839b09837940d1a55b4"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6a433ac3b5336ff4ccf12b4bcb113a177343d0160b6d6c7985bf720234b544d3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6a433ac3b5336ff4ccf12b4bcb113a177343d0160b6d6c7985bf720234b544d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6a433ac3b5336ff4ccf12b4bcb113a177343d0160b6d6c7985bf720234b544d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a9569781a207c1b57310869ad11c8b535ee9e90d7da51ebeb7ee923cf6a21e1b"
    sha256 cellar: :any,                 x86_64_linux:      "8b5290cf54b4605228d915f7cf6ce6ca199db5c905e4d555cd874fc55f509d86"
  end

  depends_on "go" => :build

  # `test do` block downloads a test fixture resource
  resource("test-parquet", :test) do
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
