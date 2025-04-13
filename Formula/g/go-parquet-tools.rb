class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.28.1.tar.gz"
  sha256 "3d40a367ccb7a2da35140aeba319f069ba139086e04d6c46e20d84b8c1ac982e"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3d24ca3df9fbd517d7acaa9152b82d876b5bdde7e104c8dc8acc8aa208bbe72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3d24ca3df9fbd517d7acaa9152b82d876b5bdde7e104c8dc8acc8aa208bbe72"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a3d24ca3df9fbd517d7acaa9152b82d876b5bdde7e104c8dc8acc8aa208bbe72"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ade9a2056737da6031707f15699eb6423949b23a988ee0601f3adcb1b7648ce"
    sha256 cellar: :any_skip_relocation, ventura:       "3ade9a2056737da6031707f15699eb6423949b23a988ee0601f3adcb1b7648ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f2975dcb20d368ca450fcb13a141402473776b635d8bdb37104b33dda55b96a"
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
