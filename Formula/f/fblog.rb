class Fblog < Formula
  desc "Small command-line JSON log viewer"
  homepage "https://github.com/brocode/fblog"
  url "https://github.com/brocode/fblog/archive/refs/tags/v4.16.0.tar.gz"
  sha256 "061288675d40ca9b70c8e3e0508f09ddee70b8a09f25c7b8ef2dbd6406d4e213"
  license "WTFPL"
  head "https://github.com/brocode/fblog.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e62c1df074a325ab3f71371381b5f5dd5f20c4ee53f05a837c83e63ac083ec2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "381480934871991b0a56987665a7ccbaa4d128ddebf621b1c8a8c7151816b67a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c80c168615dfe64c1a16b0ba3f1d68b5c07b2c06447b36374f35264830ef182"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b0de29e2041cdf11f3780ce191fc829c86589d4918a58c9bf9c708bae6fccc3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d29a71a71779a8b40b04567f42f778f564dc868723416a78a59bf779f094747"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c62f60bbbf46aed83a64559c5027ec240c30fc68d04420a8aea7748df176e09"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"fblog", "--generate-completions")

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
