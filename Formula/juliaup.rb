class Juliaup < Formula
  desc "Julia installer and version multiplexer"
  homepage "https://github.com/JuliaLang/juliaup"
  url "https://github.com/JuliaLang/juliaup/archive/v1.5.28.tar.gz"
  sha256 "2707c631de43a774a6307da1652f9a5f386980f2afe00dd08cfc9b8d800bb76c"
  license "MIT"
  head "https://github.com/JuliaLang/juliaup.git", branch: "master"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    expected = "Default  Channel  Version  Update"
    assert_equal expected, shell_output("#{bin}/juliaup status").lines.first.strip
  end
end
