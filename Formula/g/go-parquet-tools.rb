class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.58.0.tar.gz"
  sha256 "afe066eb6683bf869367076ca30c2e70aab4af3892217ebfd073bfd9fcaa2589"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "dd651fe4dd2dcd9518fe7e9ff0b77f582c7f4f6f5a2571d0b2f7420a55534928"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "dd651fe4dd2dcd9518fe7e9ff0b77f582c7f4f6f5a2571d0b2f7420a55534928"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dd651fe4dd2dcd9518fe7e9ff0b77f582c7f4f6f5a2571d0b2f7420a55534928"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8722061db43dac2ba33fda0b93b5537e53e2fd508673d559d4cd6ee8c151b6b6"
    sha256 cellar: :any,                 x86_64_linux:      "409da5dc0b2aef11fdd61273c6c4f75d32c71ed93156c150c53fdcc01e48a4be"
  end

  depends_on "go" => :build

  # `test do` block downloads a test fixture resource
  resource "test-parquet", :test do
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
