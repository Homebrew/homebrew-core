class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.55.2.tar.gz"
  sha256 "a0e6acbfab09d1923be34403b2c48f43dfa4f56b2c5237a8c877a4e28479bfa4"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "56162d03e64e914a3d378d000a0f4ce1c4506e657c7fc40822f4fdb78de8516e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "56162d03e64e914a3d378d000a0f4ce1c4506e657c7fc40822f4fdb78de8516e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "56162d03e64e914a3d378d000a0f4ce1c4506e657c7fc40822f4fdb78de8516e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d84b46398e1865e2fd3ac483ec0a64d116fbd9f87ccf139ba04fa7d3ba6a12fd"
    sha256 cellar: :any,                 x86_64_linux:      "ee108ae725794f59fe747be75d96d8c9856d21bfbd44b103508afa0935e692c7"
  end

  depends_on "go" => :build

  # `test do` block downloads a test fixture resource
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

    resource("test-parquet") do
      url "https://github.com/hangxie/parquet-tools/raw/950d21759ff3bd398d2432d10243e1bace3502c5/testdata/good.parquet"
      sha256 "daf5090fbc5523cf06df8896cf298dd5e53c058457e34766407cb6bff7522ba5"
    end

    resource("test-parquet").stage testpath

    output = shell_output("#{bin}/parquet-tools schema #{testpath}/good.parquet")
    assert_match "name=parquet_go_root", output
  end
end
