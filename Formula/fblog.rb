class Fblog < Formula
  desc "Small command-line JSON log viewer"
  homepage "https://github.com/brocode/fblog"
  url "https://github.com/brocode/fblog/archive/v4.1.0.tar.gz"
  sha256 "622fe0af24636054beca0bdaf8f184a5886a251765e762169ecfb47eed2f52ee"
  license "WTFPL"
  head "https://github.com/brocode/fblog.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf9b90c36f92db2ec2302933915e87fe56104ef40f02fe1b3b8d33b6b32d8fc8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9602925427ca716d933840bffc787db4704727e7ab685681a12c093c0b73f8e7"
    sha256 cellar: :any_skip_relocation, monterey:       "3193892a2b75f7b76660daef4977caf14fc9252de58d6af2ce7b37ac9532b0d5"
    sha256 cellar: :any_skip_relocation, big_sur:        "23cb7a7623f5b23ac193df73740fcd5a339e4b6b6bad61c92a143a36331b3090"
    sha256 cellar: :any_skip_relocation, catalina:       "2d7f9ea616ec070143b6c2d8bfd8657ed5335f4a92e7c6b2419203187c12200a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2871eb08a0f31e59e20bef69c1ba5c9b96b2c0525faa1dc1ddf679e64a1ee3dc"
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
