class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.56.3.tar.gz"
  sha256 "7ecd681942365aa97f20cf3fc209934f72e206990688b853d72aaca309f2119d"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a1d8b13716ae429f42b17b68f9b5761243818d881aebaef9bc5c004f7f3f8a33"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a1d8b13716ae429f42b17b68f9b5761243818d881aebaef9bc5c004f7f3f8a33"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a1d8b13716ae429f42b17b68f9b5761243818d881aebaef9bc5c004f7f3f8a33"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5520f1b999e6d43aa6c9c97677a0bac29cd14074e32f325e349d5188e6aee040"
    sha256 cellar: :any,                 x86_64_linux:      "6f8254c1333365ebc463596801ea8cb267bd8eef47abe9fce8e801a315c6fa15"
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
