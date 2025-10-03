class Katana < Formula
  desc "Crawling and spidering framework"
  homepage "https://github.com/projectdiscovery/katana"
  url "https://github.com/projectdiscovery/katana/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "c2ad433917ee61e613532e70b6f004884b0bdda1ac962a35b8146fc35cdcbabc"
  license "MIT"
  head "https://github.com/projectdiscovery/katana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d36effbbe9c84baf4a6336895e21f52329058e00ab804daf8db61c5ff3e3eb7e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "016725d4fb950d2b6da8a906642a2af007102ec7370a263451ec531ed2c7483e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1eb2fe709fd9b915920740cf92907c50e3c0b048e86f91abff01eaa9c07dd252"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5c3dfa46157e2589a9329a67a23ea36807ef2fd24e145aa8f39f5112fa0e627f"
    sha256 cellar: :any_skip_relocation, sonoma:        "7bc7781a5e1202939b77a0ff8bc4baf3b7a5b15c0a521c69551b137e46f9efa9"
    sha256 cellar: :any_skip_relocation, ventura:       "0e578b1b10d4c80ecda19d739a95dd979e58b883637aca1e71c0a85030d0e264"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1953de8f5c3c257c2eb0731d1cfe7fe2e5e40d469f18a7d8490acf253a90418c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7955bd622f40a4169eb2ac86be59265ff6e3b0536798715ef09537e7ed87b327"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/katana"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/katana -version 2>&1")
    assert_match "Started standard crawling", shell_output("#{bin}/katana -u 127.0.0.1 2>&1")
  end
end
