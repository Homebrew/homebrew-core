class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.54.3.tar.gz"
  sha256 "ce5dbd0bcebebac2567e1bea80f709f9fd9b227e733d367b6db815dfacadb191"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f38e50516e24494a3a2dd1a40ba3303e1e81e06fb2563816a2813483ff28c8b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f38e50516e24494a3a2dd1a40ba3303e1e81e06fb2563816a2813483ff28c8b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f38e50516e24494a3a2dd1a40ba3303e1e81e06fb2563816a2813483ff28c8b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c222d632a7f3d4397bb8affc6f57b265430d0802caa865f82137e6a07be7311"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a39885252f9256b761f44024a1b0c7af1b2d7fc16b360dfc7a7bebcf3d71dd6f"
    sha256 cellar: :any,                 x86_64_linux:  "ffce6c2912993456a62bef8c869401f087a611813b58ab5199cfd800036e8a83"
  end

  depends_on "go" => :build

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

    resource("test-parquet") do
      url "https://github.com/hangxie/parquet-tools/raw/950d21759ff3bd398d2432d10243e1bace3502c5/testdata/good.parquet"
      sha256 "daf5090fbc5523cf06df8896cf298dd5e53c058457e34766407cb6bff7522ba5"
    end

    resource("test-parquet").stage testpath

    output = shell_output("#{bin}/parquet-tools schema #{testpath}/good.parquet")
    assert_match "name=parquet_go_root", output
  end
end
