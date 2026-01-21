class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.44.1.tar.gz"
  sha256 "82881092248f8d750ecf81e8e951fdf7c665edac070ad6d3352a4b9b71d9f8d0"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "110e157efc3e373ca121fa1778258ac3f749ba77ab3273c232289467344073c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "110e157efc3e373ca121fa1778258ac3f749ba77ab3273c232289467344073c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "110e157efc3e373ca121fa1778258ac3f749ba77ab3273c232289467344073c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a86b9c4b9f3aa117947515a2eea7a52d17ba1dd12f89094fe0455355926cbf2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d36551d354d4b836c20e63b4bcf8dae56627e686bb4eea6757e114ce91abb38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd97901079ad3e295938c6faed915d7b732d382e83adac705b2ba14bf5dc5b6e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/hangxie/parquet-tools/cmd.version=v#{version}
      -X github.com/hangxie/parquet-tools/cmd.build=#{time.iso8601}
      -X github.com/hangxie/parquet-tools/cmd.source=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"parquet-tools")
  end

  test do
    resource("test-parquet") do
      url "https://github.com/hangxie/parquet-tools/raw/950d21759ff3bd398d2432d10243e1bace3502c5/testdata/good.parquet"
      sha256 "daf5090fbc5523cf06df8896cf298dd5e53c058457e34766407cb6bff7522ba5"
    end

    resource("test-parquet").stage testpath

    output = shell_output("#{bin}/parquet-tools schema #{testpath}/good.parquet")
    assert_match "name=parquet_go_root", output
  end
end
