class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.47.9.tar.gz"
  sha256 "45b077546bbfc01262fe6572e932fe552a12912f19d4ba6bd83435c714931109"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb297a976c7d46f43b20ff35f0d5f74d376829720503c60d971e17e1d9fa9525"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb297a976c7d46f43b20ff35f0d5f74d376829720503c60d971e17e1d9fa9525"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb297a976c7d46f43b20ff35f0d5f74d376829720503c60d971e17e1d9fa9525"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2eec78856afd29de871d509ebaf3cff43ca158e093315f0ad99b88ea60984de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4300278b7880686ef50615147f0f969a4f3374235e871c496e174b5852700812"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "770bbe9db22c11862984af5dad72f12df5b60065a745f3057b73e327c1af5766"
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
