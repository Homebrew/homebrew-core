class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.14.1.tar.gz"
  sha256 "510abecfb46422c500b5d1baafe4b41552e5dc22aab09d9a0b2d32d5176df87a"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0a500ad2075952681a9c91a8470f54aaf90cad537a83098045b524ae496b21e8"
    sha256 cellar: :any_skip_relocation, big_sur:       "d3b11ee4147b5288f8eea4fff5b546b6854dad98f9c02c8edd8c9848060aaa81"
    sha256 cellar: :any_skip_relocation, catalina:      "e4da583ff8b814e7e5d9566ddf26dbd0f3a58c9e498b2606d00817f0244a0504"
    sha256 cellar: :any_skip_relocation, mojave:        "740b09ccc4e5dcdb69626e0eb19bd14f7c9d809c888bb95dc9da61e4ad6f0bae"
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
