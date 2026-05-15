class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.49.1.tar.gz"
  sha256 "73a94c72e4ee6c9d1645fc110b2290d8249cbda17397cfbb0cf7fc4b1b5ec10e"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca61cf9cda527818dc3b6a7cf75b8670e5a9d6028564fbccdecae8496405f8e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca61cf9cda527818dc3b6a7cf75b8670e5a9d6028564fbccdecae8496405f8e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca61cf9cda527818dc3b6a7cf75b8670e5a9d6028564fbccdecae8496405f8e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "93cbce857ca2f2d4162721ff0d50f553e315614cacefbb674e7bdd1856945627"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ef065bdaec2787942b1b207bffe3173685c75a8f2c46b4bd6f8002b7715d2ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8be85b2bc39a5aff77cc486dbec85229ca7a2ab4ca4e1594796cd833fabf63d"
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
