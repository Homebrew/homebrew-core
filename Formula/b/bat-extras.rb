class BatExtras < Formula
  desc "Bash scripts that integrate bat with various command-line tools"
  homepage "https://github.com/eth-p/bat-extras"
  url "https://github.com/eth-p/bat-extras/archive/refs/tags/v2024.07.10.tar.gz"
  sha256 "c8e528dc5e46c0d57b187b9951fcd3c3dea890ad2df92b0f7577c4a195e8e346"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "92db55effe4560fe73df546b1353e55f5a1095bc91e55d951be575b7dd60bfa3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b70f522d0e3d96d03d821ddce77f4cf777feffa00588d2f672ef1ec1f606c909"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c02db413fe7a5df51570d186c34c80f8441e9eaec932c702ac322fe371e83164"
    sha256 cellar: :any_skip_relocation, sonoma:         "480216cdf90e14a372caf595455b173bc8712b7d9a98982c23598299a25bd434"
    sha256 cellar: :any_skip_relocation, ventura:        "b3a2a0dca3d88633c2f229f1bfee933f129f52bd7ba7be559c0000da0b429f2b"
    sha256 cellar: :any_skip_relocation, monterey:       "7f06db0afcb14516102be1d25b44d9d3c32bf22c02cfaf79b8662abd7a8d8938"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d55b1d2b3eaf756e530e596bb7e44c14078906203df8f37a3008532561e82ca4"
  end

  depends_on "bat" => [:build, :test]
  depends_on "shfmt" => :build
  depends_on "ripgrep" => :test

  def install
    system "./build.sh", "--prefix=#{prefix}", "--minify", "all", "--install"
  end

  test do
    system bin/"prettybat < /dev/null"
    system bin/"batgrep", "/usr/bin/env", bin
  end
end
