class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.39.2.tar.gz"
  sha256 "de215f02b1c0cec6c7782c2c8eeb1b86fbf4b92af4f03470d62b556e565012c3"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9e3b7e8ba80ec77fe4f5110806c494cb0c64854e4613484395a4a59d81adbd4c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e3b7e8ba80ec77fe4f5110806c494cb0c64854e4613484395a4a59d81adbd4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e3b7e8ba80ec77fe4f5110806c494cb0c64854e4613484395a4a59d81adbd4c"
    sha256 cellar: :any_skip_relocation, sonoma:        "09aedb134c24d2379fea2cb9a0d4982fdedaf073cd1a5969354300f4ce08bc7a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bec98589bd6b50f64d4a58cf18caea6cd91b37616f45be7560cc4ea1b84ee38d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1812bfc484464d1e0456091b3a73cdc1b9a584c30eb05a841e4059bb05c1b920"
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
