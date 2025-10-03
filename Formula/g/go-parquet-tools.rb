class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.36.2.tar.gz"
  sha256 "f9eac910745ff8a3976c9dd1f3fd16a6bd130154602b6045c86feba3dcb74066"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef1438cf6092f67ef84e9963ac1c3c537b0ca178c747851fb2ae887b45902664"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef1438cf6092f67ef84e9963ac1c3c537b0ca178c747851fb2ae887b45902664"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef1438cf6092f67ef84e9963ac1c3c537b0ca178c747851fb2ae887b45902664"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4e636f55dd1685956f1ab2fa0039745428b5ade3157bf825909ce9122bff931"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3b7c522fdeb17b7642f33591cf5d1251f13944d4caf606f23346830c5b82e8f"
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
