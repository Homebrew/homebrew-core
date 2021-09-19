class Narwhal < Formula
  desc "General purpose JavaScript platform for building applications"
  homepage "https://github.com/280north/narwhal"
  url "https://github.com/280north/narwhal/archive/v0.3.2.tar.gz"
  sha256 "a26ac20097839a5c7b5de665678fb76699371eea433d6e3b820d4d8de2ad4937"
  license "MIT"
  head "https://github.com/280north/narwhal.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "74667a2b115b6ee5a337b291882a06a3df9b4292a5a2b11fb5470e38abd228bc"
  end

  conflicts_with "spidermonkey", because: "both install a js binary"
  conflicts_with "elixir-build", because: "both install `json` binaries"

  def install
    rm Dir["bin/*.cmd"]
    chmod 0755, "bin/activate.bash"
    libexec.install Dir["*"]
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end
end
