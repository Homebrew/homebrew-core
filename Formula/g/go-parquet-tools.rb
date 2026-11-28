class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.58.2.tar.gz"
  sha256 "e1ea870842ddfcf858c457a69c76d169fa67c9e91e8e345f683c21c2105e672b"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    manifest_sha256 "4df4163a19e2f1ef6c3b78feeb9387d8c3af60290a9fb88f1c584362e4f99264"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "298d15b59edd5b10f49115472d34749dfeeda8a4808e98208267fd99551bb3d2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "298d15b59edd5b10f49115472d34749dfeeda8a4808e98208267fd99551bb3d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "298d15b59edd5b10f49115472d34749dfeeda8a4808e98208267fd99551bb3d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "40ccfefa2ba87760c65cb89e50b52b60c148ce6a4e217865a3f453b448b21550"
    sha256 cellar: :any,                 x86_64_linux:      "983ff60903edbaf15706fa9d97d670c3c769b978da15ba2c00fd45f46ee2a91e"
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
