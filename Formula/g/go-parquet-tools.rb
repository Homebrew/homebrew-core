class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.57.3.tar.gz"
  sha256 "0ccff478d9ceb1b73a2593aa1ec48044ef6dccd1a8cb71741fbc583e4d77fadb"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5050af6cca42a76e92d6bcda29d69feb112c502060cbe69f0120653448b75431"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5050af6cca42a76e92d6bcda29d69feb112c502060cbe69f0120653448b75431"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5050af6cca42a76e92d6bcda29d69feb112c502060cbe69f0120653448b75431"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e2d54a31032db71afc9afbd499ff87e530775368b1e6fd1cc232dbcf15a455ab"
    sha256 cellar: :any,                 x86_64_linux:      "037c654d56d0e82036d8b5e303ddc302a935d8da999dc4a47cc4c682ac275e55"
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
