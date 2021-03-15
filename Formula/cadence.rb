class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.14.0.tar.gz"
  sha256 "f1a31a90c6562ed2b5b7bbc875b7238b82b8a4792c0836e6ec11fc0cc0da1db1"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "84fbe4455dabeeedad27400ba961e34aca8cb856a229fb151be34e065d734a02"
    sha256 cellar: :any_skip_relocation, big_sur:       "d2fc3bb1964e1f8ca05187479a3ae1cdc349159a74383c607f1678d88775a936"
    sha256 cellar: :any_skip_relocation, catalina:      "f5a7ba83fa1c59bfb998cc92b98364a05a9aa1d0c0c50c9e277c397f4afc6f7b"
    sha256 cellar: :any_skip_relocation, mojave:        "6890855c13f50132f22bb684b6921ce7d1ab8bf6154c5f2374d32e797fc37cca"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./runtime/cmd/main"
  end

  test do
    (testpath/"hello.cdc").write <<~EOS
      pub fun main(): Int {
        return 0
      }
    EOS
    system "#{bin}/cadence", "hello.cdc"
  end
end
