class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.39.7.tar.gz"
  sha256 "8427195c630bed61c937b6c7a347796ad0b0d0033455b6d239478d625569a810"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ead080edf42dfdade0b418428af748ed40fe24c1c9f7dcb4307a64f446761049"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ead080edf42dfdade0b418428af748ed40fe24c1c9f7dcb4307a64f446761049"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ead080edf42dfdade0b418428af748ed40fe24c1c9f7dcb4307a64f446761049"
    sha256 cellar: :any_skip_relocation, sonoma:        "281e84337bcbcf46a9dfe68257416c5b4d01f27d0a271668251c15a3e3ae443b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1516c4a679a39f9743e3b6bfc9ad0a5e5e3256d93fe5aaa449c371549ec5050b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b25e48512ceb5a86d5dabc4b7a7d5db02748add4dd1532b983433673558def1"
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
