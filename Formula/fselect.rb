class Fselect < Formula
  desc "Find files with SQL-like queries"
  homepage "https://github.com/jhspetersson/fselect"
  url "https://github.com/jhspetersson/fselect/archive/0.6.10.tar.gz"
  sha256 "1fa86cd22fdb4a38338c343f9a917e579a6f680c961e9dca8d1a2178ab4d926b"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "7efd5dc19e81217d688b06223c7803892cd95a906e842ab2000c0992ddf42ca1" => :catalina
    sha256 "020cb9b7a9a051042deae41ed35583e44af1e00602646a665418e5127f6a3011" => :mojave
    sha256 "2f25c750b2dbbf58ceddf122cbf681eb9368201bca13ed8f5664978f1eedd22b" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    touch testpath/"test.txt"
    cmd = "#{bin}/fselect name from . where name = '*.txt'"
    assert_match "test.txt", shell_output(cmd).chomp
  end
end
