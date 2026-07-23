class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.52.2.tar.gz"
  sha256 "c437f915a321b4c4ed9388532d5e3a40fb74c2fc7d04d5958fc6817cbe0f4852"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a9a84decbca1ed4730581e30f6a0de15277f1a1703d26420a11e10c811fc892"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a9a84decbca1ed4730581e30f6a0de15277f1a1703d26420a11e10c811fc892"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a9a84decbca1ed4730581e30f6a0de15277f1a1703d26420a11e10c811fc892"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f813f123319dcf76794fad815595f48d8b31fe3d481b196e4cb2b003fa75db7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b26f976a90f9268852659692bdbbf11673b008d1c891690cf4bd9a642721e50"
    sha256 cellar: :any,                 x86_64_linux:  "cc66e1b2bb089e00fd62dc4dea8d8f6bcb4d476bb0d73b98514a7e475ff4f1ae"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
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
