class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.32.4.tar.gz"
  sha256 "f5113788e858860641408dbf0a99cb956c974e9db9a126663849afe03db8792d"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a140874ba65e9f764a2ff512ff9987556681c91ee57706f87c9d50930bfad634"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a140874ba65e9f764a2ff512ff9987556681c91ee57706f87c9d50930bfad634"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a140874ba65e9f764a2ff512ff9987556681c91ee57706f87c9d50930bfad634"
    sha256 cellar: :any_skip_relocation, sonoma:        "a181d2dd599cb247db1977a673b4b7ef384022109203e9c36dfbace93e074694"
    sha256 cellar: :any_skip_relocation, ventura:       "a181d2dd599cb247db1977a673b4b7ef384022109203e9c36dfbace93e074694"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a0fe6b03e1269e47d3dbbf947e6c3bd10c1bcfeb36c2903de4c9db664b2c6dc"
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
