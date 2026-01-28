class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.46.1.tar.gz"
  sha256 "eb9ce717fb298f15ea709c240b1800b11d543e81d2e496067ebebe036cca478a"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d5e9a035480d83bdf59de788843706906baf662ebfd4631d09cc77c127618c95"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5e9a035480d83bdf59de788843706906baf662ebfd4631d09cc77c127618c95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5e9a035480d83bdf59de788843706906baf662ebfd4631d09cc77c127618c95"
    sha256 cellar: :any_skip_relocation, sonoma:        "69102be3e7a01735dfa3962f1d5e340b770535ef5a27a7045156aa37108d4f69"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0282ec1971c6defdc350fb9ca2c1b989675e59f6e52c3137e1c28e37071d0809"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b24b632ecbcdcd0b2458a232641206949e318dd94aaed4e6b005075899d0c1e"
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
