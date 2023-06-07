class Nef < Formula
  desc "💊 steroids for Xcode Playgrounds"
  homepage "https://nef.bow-swift.io"
  url "https://github.com/bow-swift/nef/archive/0.7.1.tar.gz"
  sha256 "147b8723d65ababedd04abf2ea4445c2b16dd7c18814a92182ae61978eb1152e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6cd8f9c972f707a1c3a05f95c68387f56d9a730bb4a3d42a06fde72ecb481984"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8918c48c922141c187e2271884864118e01b8cc821d53d3bf82f25ed61cf6075"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b8453d3a8cb3b1cdcc4c042f63efd772a70b2e28f822faca6adf710688f7cf9b"
    sha256 cellar: :any_skip_relocation, ventura:        "92e95815627f276ef3800d4795ab8f724d3f3e9eea8a3fe38761d7117d11dd86"
    sha256 cellar: :any_skip_relocation, monterey:       "8841fde2a11375a65c32ac4e8c88dfc44f64935921a71fa546026fb40e8acef1"
    sha256 cellar: :any_skip_relocation, big_sur:        "4a80e27e8474a6100f79b2845121660f3fec14e1f9f90a09b12f5b9fc804b5ef"
  end

  depends_on :macos
  depends_on xcode: "13.1"

  def install
    system "make", "install", "prefix=#{prefix}", "version=#{version}"
  end

  test do
    system "#{bin}/nef", "markdown",
           "--project", "#{share}/tests/Documentation.app",
           "--output", "#{testpath}/nef"
    assert_path_exists "#{testpath}/nef/library/apis.md"
  end
end
