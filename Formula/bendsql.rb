class Bendsql < Formula
  desc "Databend Native Command-Line Tool"
  homepage "https://databend.rs"
  url "https://github.com/datafuselabs/databend-client/archive/v0.2.5.tar.gz"
  sha256 "8b3b728a4ceba0dc40760d83ba109d9bca24988d24b8998aaada15eb8308f560"
  license "Apache-2.0"

  depends_on "rust" => :build

  def install
    build_root = buildpath/"cli"
    cd build_root do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    output = shell_output("#{bin}/bendsql -V")
    assert_match "bendsql 0.2.5\n", output
  end
end
