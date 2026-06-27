class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.51.0.tar.gz"
  sha256 "8df9875d2f3c52e2b4a8ba2d98c1da06338680402ad8e07ec35a3fddcc829a94"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c3729b2933e73d74fc4f14c232d9792884cf3b8b4dbbe85f28ba890436ce122"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c3729b2933e73d74fc4f14c232d9792884cf3b8b4dbbe85f28ba890436ce122"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c3729b2933e73d74fc4f14c232d9792884cf3b8b4dbbe85f28ba890436ce122"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f0402e4b79f2b436d34c68574b1943522289b9ac132da90bed26accec3e0471"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd47cc093b879d23f8e0f12992c757b21730fdfa652b0cd2a7e61bc42f5f1e46"
    sha256 cellar: :any,                 x86_64_linux:  "7358a9cf28455bd034607df6237f3ec5b1f54b3519e5314bf6dfcc8c7fab4021"
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
