class Fblog < Formula
  desc "Small command-line JSON log viewer"
  homepage "https://github.com/brocode/fblog"
  url "https://github.com/brocode/fblog/archive/v4.0.0.tar.gz"
  sha256 "99435529eec82e65b58dcbccaece6f7e015d110486189c0f4ceaf2bc5f117771"
  license "WTFPL"
  head "https://github.com/brocode/fblog.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b1db18811932b40cf1a9f94d1971ddf3448db57231b1f83cc84db77d7a568dd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c24a0d5a92f5a08cf82ff261d58e57fa561faa05b0c2cc3defe0173412f2acff"
    sha256 cellar: :any_skip_relocation, monterey:       "afb21cec2692bf1b126f3142c919b38a090faf02a388a7e0995bb1f1cf039dd7"
    sha256 cellar: :any_skip_relocation, big_sur:        "7f863f6ae8e2799d289e93c73cfa73edf71b3fd191632b3925e6dd3e0412be4f"
    sha256 cellar: :any_skip_relocation, catalina:       "8754f9d398a9feaad6eae33b26dc1cde34492e10e5ec987cbe3e205ead12ec45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94daeab7ce1467e5e5b33deb14b64d0d5832ef7523fd021b26b91cd513023b73"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    # Install a sample log for testing purposes
    pkgshare.install "sample.json.log"
  end

  test do
    output = shell_output("#{bin}/fblog #{pkgshare/"sample.json.log"}")

    assert_match "Trust key rsa-43fe6c3d-6242-11e7-8b0c-02420a000007 found in cache", output
    assert_match "Content-Type set both in header", output
    assert_match "Request: Success", output
  end
end
