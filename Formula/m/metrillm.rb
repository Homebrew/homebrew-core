class Metrillm < Formula
  desc "Benchmark local LLM models for speed, quality, and hardware fit"
  homepage "https://github.com/MetriLLM/metrillm"
  url "https://registry.npmjs.org/metrillm/-/metrillm-0.1.1.tgz"
  sha256 "0a194d0735497ef8de0e60800a1d4fa79722e69f8c3caeaaa61808e19cfd242b"
  license "Apache-2.0"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    ENV["NO_COLOR"] = "1"
    output = shell_output("#{bin}/metrillm bench --export invalid 2>&1", 1)
    assert_match "Invalid --export format", output
  end
end
