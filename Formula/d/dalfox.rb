class Dalfox < Formula
  desc "XSS scanner and utility focused on automation"
  homepage "https://dalfox.hahwul.com"
  url "https://github.com/hahwul/dalfox/archive/refs/tags/v2.12.0.tar.gz"
  sha256 "b87848b17cac23352d674e63fee554ae6b976a53fe3e62822512232030430cd5"
  license "MIT"
  head "https://github.com/hahwul/dalfox.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b9c0218ff805fd1927381e6368303cb0c7c094b6f24ffc35bcde5d7f91af597b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9c0218ff805fd1927381e6368303cb0c7c094b6f24ffc35bcde5d7f91af597b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9c0218ff805fd1927381e6368303cb0c7c094b6f24ffc35bcde5d7f91af597b"
    sha256 cellar: :any_skip_relocation, sonoma:        "b15343c0af3360b9928245305c51b58d9551c3064bcb3d9404d50cb44e06f3bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6a002ddfa96025c7693b1607b3d591d874651c89517eace68f1c7e9cae273a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b9e95b6d2bf7f3512476fd112cef2ce22aa39b1c7e10249f0187f960e6140c8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"dalfox", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dalfox version 2>&1")

    url = "http://testphp.vulnweb.com/listproducts.php?cat=123&artist=123&asdf=ff"
    output = shell_output("#{bin}/dalfox url \"#{url}\" 2>&1")
    assert_match "Finish Scan!", output
  end
end
