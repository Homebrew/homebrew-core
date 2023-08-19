class Fblog < Formula
  desc "Small command-line JSON log viewer"
  homepage "https://github.com/brocode/fblog"
  url "https://github.com/brocode/fblog/archive/v4.4.0.tar.gz"
  sha256 "5ac8beb5885359744f84fccd6d941d682842ed32ee0e229dc8edd2b183ce0667"
  license "WTFPL"
  head "https://github.com/brocode/fblog.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f61f90023c951da8586b551853a48bfb36aaaadd3b170a22c4953913e79636d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37ad4c7f2c2ca8bf8d144a1cbc3b2d6f5b55be34d5edfa4ebcc30489adad0efc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ffa80dff8fa7ff7ec7689bdd7e4d8269438f934e242ae54faecbd11642454904"
    sha256 cellar: :any_skip_relocation, ventura:        "6e935e2a976816e7db40f7040b8bfe69ff11e10540e2a64bc4bbf225f3182adf"
    sha256 cellar: :any_skip_relocation, monterey:       "5b27a82fa1d7189721da20d1bc4ea03e96d0f2b2cc25da60321df29ade6b9f5a"
    sha256 cellar: :any_skip_relocation, big_sur:        "e80faa02b5aae39af9c933b981b329bfe2174e9505b2586100b2c0ad74d6b694"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2348344868c1773fa34bd6164b8a62f18a541a940176524a4f54662f705dbb78"
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
