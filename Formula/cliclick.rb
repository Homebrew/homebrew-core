class Cliclick < Formula
  desc "Tool for emulating mouse and keyboard events"
  homepage "https://www.bluem.net/jump/cliclick/"
  url "https://github.com/BlueM/cliclick/archive/5.0.1.tar.gz"
  sha256 "798fb8b26f6a42b5002ca58e018b91f7677162c4f035b38aee8d905829db64a7"
  license "BSD-3-Clause"
  head "https://github.com/BlueM/cliclick.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "49a85737d23a53f6a29a3084c502825686491bc3500fc3ae24aa78317e2e6cb6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "38bed03738e5b08fd7956b06168522bf50649b89d77f9db7f11ede0556c769f7"
    sha256 cellar: :any_skip_relocation, monterey:       "fc9ab224818d422a7b9fadc53926530044465f74ba407e378b779f90bcc36df2"
    sha256 cellar: :any_skip_relocation, big_sur:        "40accabe00d35eba6b328cca78e2c1009be79bc0dada3c14689919b2fd72fa39"
    sha256 cellar: :any_skip_relocation, catalina:       "f80bcf05d0c6e682ca479a2692288eb31021a9108043e2c80251bdc9d3ee31a5"
    sha256 cellar: :any_skip_relocation, mojave:         "bfe0d98cf52c7e6b14ae1eafa1a8640880af33f9e121415599ff0528152c1b42"
  end

  depends_on :macos

  def install
    system "make"
    bin.install "cliclick"
  end

  test do
    system bin/"cliclick", "p:OK"
  end
end
