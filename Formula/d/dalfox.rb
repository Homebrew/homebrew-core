class Dalfox < Formula
  desc "XSS scanner and utility focused on automation"
  homepage "https://dalfox.hahwul.com"
  url "https://github.com/hahwul/dalfox/archive/refs/tags/v3.2.3.tar.gz"
  sha256 "05a9d84ba549cc92516f7c3c488d8e60cd34fc47f58f55e734db4091e249079c"
  license "MIT"
  head "https://github.com/hahwul/dalfox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "247075c9c3516d4375a19406a9c622636f17cb65c984b1d0b6166b4dfc3aa278"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d4fa457572e78d1c63979128fad4dd8f77487e2e8546e31a647eee86d7e76b55"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "17c7401104195d51b70f5ad2c6e6bd5c979be7d3a7817778bdfc3e03a302ace6"
    sha256 cellar: :any,                 arm64_linux:       "61d21077ede7feb05d7965c7834fea001c4cbeace3dcdf64b75aed6b1b9c4c29"
    sha256 cellar: :any,                 x86_64_linux:      "b518bdc083b7fc1debe252db2a1e4dacb38ece5225c181a2277f4d7e8f311304"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dalfox -V 2>&1")

    url = "https://pentest-ground.com:4280/vulnerabilities/xss_r/"
    output = shell_output("#{bin}/dalfox scan \"#{url}\" 2>&1", 1)
    assert_match "scan completed", output
  end
end
