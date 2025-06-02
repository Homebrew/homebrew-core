class Fblog < Formula
  desc "Small command-line JSON log viewer"
  homepage "https://github.com/brocode/fblog"
  url "https://github.com/brocode/fblog/archive/refs/tags/v4.14.0.tar.gz"
  sha256 "1474b5fc511e52635d0e95ebd3e139f702794c1570286fd01f6b93ce82282c85"
  license "WTFPL"
  head "https://github.com/brocode/fblog.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77af4a66983d5cc61175df28e30945db3f70bbaa44cd9afe1c8227e7fa566773"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e93f20ea9990b0411fe95e8a59d1fa0ae9bfcb4a7833fdc3b13e34e9c475231"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c65bde5830c0d0fe471fabe59831f4d1dfea3a8222869cd2e0178e4e0e0e4059"
    sha256 cellar: :any_skip_relocation, sonoma:        "f27eb1b6ecf7e917e934577cc85c6f1f146fddbe8dd20a791b6e86c25d9fe535"
    sha256 cellar: :any_skip_relocation, ventura:       "289a02cb2cf5e1780f22a63bcbf6204e97dbf49af04114f440238b02f36a1124"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9a69946c769b0909467778c508dc11f7c5b707aacc7ec30e8ae0b2503e7735d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3452d14b068a9a4df39b2f5cc4f45b19b986b3f3e0879b71cb28e2fdcf93f80a"
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
