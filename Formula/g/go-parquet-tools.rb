class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.28.3.tar.gz"
  sha256 "d71530927d732460f9ea4f7696c7bb51334ce2e7024c5b77ac14d9baa090198b"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e202ec9f273af9ecba0159e3c8f82ab11f3f4dde657f38fc26e846ab1c59ecc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e202ec9f273af9ecba0159e3c8f82ab11f3f4dde657f38fc26e846ab1c59ecc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1e202ec9f273af9ecba0159e3c8f82ab11f3f4dde657f38fc26e846ab1c59ecc"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc4eef88fbb93fc3ecf371e6bc15e739d261599d826c4121a41b7f48c3f49984"
    sha256 cellar: :any_skip_relocation, ventura:       "cc4eef88fbb93fc3ecf371e6bc15e739d261599d826c4121a41b7f48c3f49984"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae48db02e01376961e43a83331de42f7c6677422db8490bb19b178b09b9c7ec3"
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
    assert_match "name=Parquet_go_root", output
  end
end
