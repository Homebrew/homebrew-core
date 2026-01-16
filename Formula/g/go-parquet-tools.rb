class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.43.0.tar.gz"
  sha256 "cadbb992fa037e89b8794df0023a4b1184c8210a38310fa0d2f932db25e3de70"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c51037a88fa02936da5d7db37acb0aae2c67ddaa6ea3c0dea557334b5aa1d401"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c51037a88fa02936da5d7db37acb0aae2c67ddaa6ea3c0dea557334b5aa1d401"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c51037a88fa02936da5d7db37acb0aae2c67ddaa6ea3c0dea557334b5aa1d401"
    sha256 cellar: :any_skip_relocation, sonoma:        "69f296f2f55babce66ac41acea80df688e4fff4bbed5d5305ed01a448f1ed344"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3aaa6a885b6921ffe2acf33517dcd9d8f7ad7739fb621f623b544a8463fe303"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9fbc84f0df417018205910c0d0cff980ec5a23076eda9bca2e2489ab60380804"
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
