class Dalfox < Formula
  desc "XSS scanner and utility focused on automation"
  homepage "https://dalfox.hahwul.com"
  url "https://github.com/hahwul/dalfox/archive/refs/tags/v2.12.0.tar.gz"
  sha256 "b87848b17cac23352d674e63fee554ae6b976a53fe3e62822512232030430cd5"
  license "MIT"
  head "https://github.com/hahwul/dalfox.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "adb975deecc8e03c75c980ad6787452fed58a5d12951d11537c94eefcb11a841"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "511a887b38f2fca677528e0c5c90f540a85b931ea28d4474062b83c92b23f31b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "511a887b38f2fca677528e0c5c90f540a85b931ea28d4474062b83c92b23f31b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "511a887b38f2fca677528e0c5c90f540a85b931ea28d4474062b83c92b23f31b"
    sha256 cellar: :any_skip_relocation, sonoma:        "54a0c02b8dbfb0aec78818fa5aa7f843f0936ce46afc5b0a52fc69c79c8add7a"
    sha256 cellar: :any_skip_relocation, ventura:       "54a0c02b8dbfb0aec78818fa5aa7f843f0936ce46afc5b0a52fc69c79c8add7a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2bba9992dda0d565c0eab6acc973e014c947dc98cdf6db426da990ffbf577c49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45314adf0430c025d71fc1154ece4ea12e4f80da6335beb55f12fcea02c3575d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"dalfox", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dalfox version 2>&1")

    url = "http://testphp.vulnweb.com/listproducts.php?cat=123&artist=123&asdf=ff"
    output = shell_output("#{bin}/dalfox url \"#{url}\" 2>&1")
    assert_match "Finish Scan!", output
  end
end
