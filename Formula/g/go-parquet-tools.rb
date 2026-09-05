class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.55.0.tar.gz"
  sha256 "e1eab73ede74fc7262d179f3edbfd8f11f79b89b7f9c4120b414c0e0cdd106fa"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b28d306ca6d182463773b505dbfc157ca181fc2ed5c087af11be02fa36283de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b28d306ca6d182463773b505dbfc157ca181fc2ed5c087af11be02fa36283de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b28d306ca6d182463773b505dbfc157ca181fc2ed5c087af11be02fa36283de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99617bc3a84ecb8477578bea50ac870ed428ab528922b45030f0bb9e99a1e913"
    sha256 cellar: :any,                 x86_64_linux:  "c0a87a35bf1fddd00b2474876995d49af51ba4ffb610b8a4dd82c2bc95b1b45b"
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
