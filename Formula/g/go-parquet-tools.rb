class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.25.10.tar.gz"
  sha256 "4255a765c295603fdc51b3479ff8d0defbb864971b2e1f732d1278231603b18b"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc38ca450eb9d0f1843e6e10e93cc107ecb804f0cf1d91f9fb77032b387175ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc38ca450eb9d0f1843e6e10e93cc107ecb804f0cf1d91f9fb77032b387175ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cc38ca450eb9d0f1843e6e10e93cc107ecb804f0cf1d91f9fb77032b387175ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "74cb4880214635871a752c27a47c76400c52860400e2bede6c69ea7d9a1f0104"
    sha256 cellar: :any_skip_relocation, ventura:       "74cb4880214635871a752c27a47c76400c52860400e2bede6c69ea7d9a1f0104"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66fc030869fd9fe6e0781601ce1b2da8797bcdc68857d563468c4d756c7310d2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/hangxie/parquet-tools/cmd.version=v#{version}
      -X github.com/hangxie/parquet-tools/cmd.build=#{time.iso8601}
      -X github.com/hangxie/parquet-tools/cmd.gitHash=ef7222f
      -X github.com/hangxie/parquet-tools/cmd.source=Homebrew
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"parquet-tools")
  end

  test do
    resource("test-parquet") do
      url "https://github.com/hangxie/parquet-tools/raw/v1.25.9/testdata/good.parquet"
      sha256 "daf5090fbc5523cf06df8896cf298dd5e53c058457e34766407cb6bff7522ba5"
    end

    resource("test-parquet").stage testpath

    output = shell_output("#{bin}/parquet-tools schema #{testpath}/good.parquet")
    assert_match "name=Parquet_go_root", output
  end
end
