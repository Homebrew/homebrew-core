class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://github.com/hangxie/parquet-tools/archive/v1.0.0.tar.gz"
  sha256 "9ae1156f957dd26aaad76d08d4d95c7e1f50c191179c66f6d8e057131c048495"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b233737eb56868ab62e2a9d64ee4f798b97088cba2834671946112c60ac4cc46"
    sha256 cellar: :any_skip_relocation, big_sur:       "7dc5db8e42bb8b8eb147738a5c9a41eba06f18bc9cc29bc7aef356a8376deec6"
    sha256 cellar: :any_skip_relocation, catalina:      "8a452452cdd5e32e9a682be1290506d70b8519b780d3039239f9c7bc98d12976"
    sha256 cellar: :any_skip_relocation, mojave:        "24aaac5f6c5875456c953df2413e0357f9d9ccd091e79c8b36ce86d027bcd624"
  end

  depends_on "go" => :build

  conflicts_with "parquet-tools", because: "both install `parquet-tools` executables"

  resource("test-parquet") do
    url "https://github.com/hangxie/parquet-tools/raw/v1.0.0/cmd/testdata/good.parquet"
    sha256 "d6ab36ac8bd23da136b7f8bd2a6c188db6421ea4e85870e247e57ddf554584ed"
  end

  def install
    system "go", "build", "-ldflags", "-s -w -X main.version=v#{version} -X main.build=#{Time.now.iso8601}", *std_go_args, "-o", bin/"parquet-tools"
  end

  test do
    resource("test-parquet").stage testpath

    output = shell_output("#{bin}/parquet-tools schema #{testpath}/good.parquet")
    assert_match "name=Parquet_go_root", output
  end
end
