class Fblog < Formula
  desc "Small command-line JSON log viewer"
  homepage "https://github.com/brocode/fblog"
  url "https://github.com/brocode/fblog/archive/refs/tags/v4.13.1.tar.gz"
  sha256 "0212dd590cdcb4794a44ea79535ba298c1e971bb344a248fb84528777b0998f1"
  license "WTFPL"
  head "https://github.com/brocode/fblog.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6bb35ff146fd1409fceeda88135dbb8a3038dd052ca29dcad94fca29b3407036"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5eb80841e5eb4b5a45651d36956c246a014ff77b583c642e55aeeb43f4220e87"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b5db8c09137e39a27eccb7b3b88d59c6b91c1d0c84b13de44cfdf29a2635fe32"
    sha256 cellar: :any_skip_relocation, sonoma:        "83fd40354f5f1812199343c7acf8df4cabae46b46cb9a5791cf5b79c4785d559"
    sha256 cellar: :any_skip_relocation, ventura:       "b6a47871ea357767785a7b1d8d8bc5f313e4e630d96a1aa5a03cb2ad3a279be8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0cf0822428bb0d7fe47572c153f2fb60644dae34c7ba6b0b661f92511c9ec97d"
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
