class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.57.4.tar.gz"
  sha256 "1af87863f2ed760670b8fb016890ec2e3146884d089ef466dd4099cd5133d613"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d6e10d47d6da7df66b1f55dac118e38eac0234036b26dc82dee13e7a69b69a10"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d6e10d47d6da7df66b1f55dac118e38eac0234036b26dc82dee13e7a69b69a10"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d6e10d47d6da7df66b1f55dac118e38eac0234036b26dc82dee13e7a69b69a10"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "db1facb85dc10321ae1ff4c8b357c32ceeab0dc1a74a24de33ca1aa59d789ffc"
    sha256 cellar: :any,                 x86_64_linux:      "d00327bd651facd54965d15b59f27b284ad70f879bc1c652b68c0ed52632b938"
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
