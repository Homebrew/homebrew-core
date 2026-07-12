class Nail < Formula
  desc "CLI for exploring, filtering, and transforming Parquet, CSV, and Excel files"
  homepage "https://github.com/Vitruves/nail-parquet"
  url "https://github.com/Vitruves/nail-parquet/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "2fe3d96f3e88e58c3ba7e065e17be3bcaa7ac5fb037d6ae8a50d704541cdbb65"
  license "MIT"
  head "https://github.com/Vitruves/nail-parquet.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"data.csv").write <<~EOS
      id,name,value
      1,alpha,10
      2,beta,20
    EOS
    output = shell_output("#{bin}/nail head #{testpath}/data.csv")
    assert_match "alpha", output
  end
end
