class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.54.4.tar.gz"
  sha256 "2340563c68041cf07a27d4d031b10e95f9d7703a8ffa4e7b9636fa4e9686d641"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e4f8589d87402572b0e76835de2990079b3ab99d49002a97f12daeecf4b05007"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4f8589d87402572b0e76835de2990079b3ab99d49002a97f12daeecf4b05007"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4f8589d87402572b0e76835de2990079b3ab99d49002a97f12daeecf4b05007"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3ef73a7552bd460059f7e5adc2ac9ac89100204507f9a9476000bc673ff4a2d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16dfe7b1dcd82c9f3a4bd6c095a6cb2f50abe7f18b19714265565b35408b454a"
    sha256 cellar: :any,                 x86_64_linux:  "85f943533b47d633bdbedfb64511dd8e5fa268610ac31746ded8452cc924fa9e"
  end

  depends_on "go" => :build

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
