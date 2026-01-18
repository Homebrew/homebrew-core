class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.44.0.tar.gz"
  sha256 "3752dc399f54e9a65cb6da2460833cb79ed55e2e5f19239b06be0e2a9492026e"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "97887db3d9e76ee9843ab4277214db2e227df2580aeeef3f02b325913436f87b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97887db3d9e76ee9843ab4277214db2e227df2580aeeef3f02b325913436f87b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97887db3d9e76ee9843ab4277214db2e227df2580aeeef3f02b325913436f87b"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ad6ab9a3427e3e5543aa46e71e9a8cd9d7105d5b1684371b7aa4dda6e5e3935"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f8b9d48df3a1704ef0a88af9acc48800a42310a73d83a8928bb9c1f72ed6ddd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce06dfa8fb1d005b2a1d45913878a54cffb005ffd241beb76b6e313c3cd1613e"
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
