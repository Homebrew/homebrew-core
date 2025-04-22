class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.28.2.tar.gz"
  sha256 "31942014b89b285d8c2589c4cacfc04cd49f631ea48722c6816dbf781bdff8a6"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fdfda0825b08e576b74c6cb777e337e5582e117989ba7fd2fa724bc64e02af15"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fdfda0825b08e576b74c6cb777e337e5582e117989ba7fd2fa724bc64e02af15"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fdfda0825b08e576b74c6cb777e337e5582e117989ba7fd2fa724bc64e02af15"
    sha256 cellar: :any_skip_relocation, sonoma:        "c13b659b86821df58f33b88af316098fc25ac198aa7b7e229c26a08a6108eebc"
    sha256 cellar: :any_skip_relocation, ventura:       "c13b659b86821df58f33b88af316098fc25ac198aa7b7e229c26a08a6108eebc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5fb35fccb2b5dc66ba4c2acce1de03b578117a992ff20e650b998ab1d04c1d10"
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
    assert_match "name=Parquet_go_root", output
  end
end
