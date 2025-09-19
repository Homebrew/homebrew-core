class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.36.0.tar.gz"
  sha256 "f5ab52ed06bd85a771602aac3b68e7bcd519405903de17e1a422af8cf62622c5"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f25ae7ef07b420f1df6f263c0e62008886f1e1e6df5f632b91393e3e5e5d2c45"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f25ae7ef07b420f1df6f263c0e62008886f1e1e6df5f632b91393e3e5e5d2c45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f25ae7ef07b420f1df6f263c0e62008886f1e1e6df5f632b91393e3e5e5d2c45"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e825b4d9d711888415ebbc0fc86975a3ecac000c75d54c95cafea3a3f077fc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ea6cb68200e4396edbd4f8fd5b9e9547b88e87d04be715ba72ac404c7afd9d4"
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
