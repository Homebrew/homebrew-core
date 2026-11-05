class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.57.2.tar.gz"
  sha256 "1eb0ef9184f14ea99a18e1ba863da7a34914b36e0cd1c96677918740601e4d49"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "08e4ff6fea5578234d564da3764c545bd60f00f0d10157d27c93d316f0d6a660"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "08e4ff6fea5578234d564da3764c545bd60f00f0d10157d27c93d316f0d6a660"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "08e4ff6fea5578234d564da3764c545bd60f00f0d10157d27c93d316f0d6a660"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "741e658951da8b12fde52b2341a6dd65d27e30ee7e2cf289a5698e5e6ada2e59"
    sha256 cellar: :any,                 x86_64_linux:      "a431a8fe8f9ad4dc5001f72b53162f1fb95a72370a80c56f25afb1ff5bf2026f"
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
