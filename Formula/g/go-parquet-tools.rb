class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.39.1.tar.gz"
  sha256 "e61813aa2e24c7836144686fe80c6fd9f3de3f9af5842f36206a0ae0cd01ac47"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a6184c3ccf8df3353c2cf92ed4deef58a1309803cf89dff6e2c11918e48edcde"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6184c3ccf8df3353c2cf92ed4deef58a1309803cf89dff6e2c11918e48edcde"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6184c3ccf8df3353c2cf92ed4deef58a1309803cf89dff6e2c11918e48edcde"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a1c4b8a954cddce020f7789ed326b000531e0638f5fea87feaa9775c43ecf46"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1b9c701794a4a1978dfbb40e4d9fd1568475a2954603197af50ed9d5baa3894"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb7778238bb69b077056e476b30794b51ea7c28c054e3c8286804e3485f8fe64"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/hangxie/parquet-tools/cmd.version=v#{version}
      -X github.com/hangxie/parquet-tools/cmd.build=#{time.iso8601}
      -X github.com/hangxie/parquet-tools/cmd.source=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"parquet-tools")
  end

  test do
    resource("test-parquet") do
      url "https://github.com/hangxie/parquet-tools/raw/950d21759ff3bd398d2432d10243e1bace3502c5/testdata/good.parquet"
      sha256 "daf5090fbc5523cf06df8896cf298dd5e53c058457e34766407cb6bff7522ba5"
    end

    resource("test-parquet").stage testpath

    output = shell_output("#{bin}/parquet-tools schema #{testpath}/good.parquet")
    assert_match "name=parquet_go_root", output
  end
end
