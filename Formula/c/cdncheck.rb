class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https://projectdiscovery.io"
  url "https://github.com/projectdiscovery/cdncheck/archive/refs/tags/v1.2.50.tar.gz"
  sha256 "0c702bcb9fb59409a50539c5ad44ea6948b6aebe14d0dad1050a5148cbf8b6ad"
  license "MIT"
  head "https://github.com/projectdiscovery/cdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4d5708fdae3848e904d0dedf720f57685699df076a58d4b37238b1e4103ce94f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15400ebe2788cd632681d84534d38211bcf5bce53416071718b63d0ab41f0c22"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f863236bea799d7ef243adb72508acf16da053a83a21168d8a96abbc421bf27"
    sha256 cellar: :any_skip_relocation, sonoma:        "636c700d58c8039ea4d9cb02396b7ca9b89a19921f31a66331a30f8a5c5c3b53"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d793bf1b363e817b7c0d0efcc2fbac71e7de6b119bd495fb4a87c19b4e1a1365"
    sha256 cellar: :any,                 x86_64_linux:  "57a226eeaa9ca8137d41fe686e4d48e6eb4155cca768cb559c152f8fca5e22dc"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/cdncheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cdncheck -version 2>&1")

    assert_match "cdncheck", shell_output("#{bin}/cdncheck -i 1.1.1.1 2>&1")
  end
end
