class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.58.3.tar.gz"
  sha256 "a75b01479207a6db3260ea1c975f635311f8d5a90c0fa7710fb34859d8f8837a"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    manifest_sha256 "7582d3061dd680e659684d063c49fb175a4f7bda53d48c1eb6bb7ca649b800cb"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4cb5820fbb4cfbfcd10d6205404b48ea038118a16caa499c8be207e3d5d7366d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4cb5820fbb4cfbfcd10d6205404b48ea038118a16caa499c8be207e3d5d7366d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4cb5820fbb4cfbfcd10d6205404b48ea038118a16caa499c8be207e3d5d7366d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7695cabda9828e4cd945f13ac8c4d1784233738abd739dfaccd6795ce74eccb6"
    sha256 cellar: :any,                 x86_64_linux:      "59680991e685923b88ba557ae04549d1bf0418030f487d88b13fb57c421b0a67"
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
