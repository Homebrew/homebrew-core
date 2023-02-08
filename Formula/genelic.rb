class Genelic < Formula
  desc "⚖️ Generate a license file for your project easily"
  homepage "https://github.com/fus1ondev/genelic#readme"
  url "https://github.com/fus1ondev/genelic/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "91c52b979ba5438f136936e90b829c6eff9e6014f2c7f0de9ffe8776c8996d74"
  license "MIT"

  depends_on "deno" => :build

  def install
    system "deno", "compile", "--allow-read", "--allow-write", "--allow-env", "--output=genelic", "mod.ts"

    bin.install "genelic"
  end

  test do
    assert_match "Title", shell_output("genelic list")
  end
end
