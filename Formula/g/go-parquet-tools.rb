class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.34.2.tar.gz"
  sha256 "a121c03f1e84d73fd6107719952af0a0c81057dfd386f190df2214668b908f7f"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ead3a10f32ab72d5dc7e315eb56a19b21c8286e3ec6c4a858bb43a881490660"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ead3a10f32ab72d5dc7e315eb56a19b21c8286e3ec6c4a858bb43a881490660"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3ead3a10f32ab72d5dc7e315eb56a19b21c8286e3ec6c4a858bb43a881490660"
    sha256 cellar: :any_skip_relocation, sonoma:        "3fb2a4fa754ac58547aff718b273b273ae5a9ee29936f524beee206cc27a8baa"
    sha256 cellar: :any_skip_relocation, ventura:       "3fb2a4fa754ac58547aff718b273b273ae5a9ee29936f524beee206cc27a8baa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84a1e28265d8ec04a33bb3fd084cfaf502ce0628d683066944b0ff443de52cce"
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
