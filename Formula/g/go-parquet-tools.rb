class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.35.1.tar.gz"
  sha256 "575c6feee13d8a4eef4b763c93bd84be1c361fd9e8f42cea2bed945c4505dd82"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0038755c2bd04f190471f701eafac39993254ee84a563b7e9e98d9cc80ba14a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0038755c2bd04f190471f701eafac39993254ee84a563b7e9e98d9cc80ba14a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0038755c2bd04f190471f701eafac39993254ee84a563b7e9e98d9cc80ba14a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ea09964afce52fb6502c08786a43875afebd6cf9042afc61bf841a403d54283"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4f9bcd69bb8086a4af786e8e0d8e655c8e2119d4f0cc483d7277d7ce378f7ca"
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
