class Dldfs < Formula
  desc "Fast multi-connection CLI download manager"
  homepage "https://github.com/Mark-0731/dldfs"
  url "https://github.com/Mark-0731/dldfs/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "1a9ce713acab79c89b48e974689d3da2499dedfb8c4abae0a3c0c5132ce29733"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}/dldfs --help")
    assert_match "Multiple concurrent connections", output
  end
end
