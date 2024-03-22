class N < Formula
  desc "Node version management"
  homepage "https://github.com/tj/n"
  url "https://github.com/tj/n/archive/refs/tags/v9.2.1.tar.gz"
  sha256 "f112c291a1f441a14971ce5ee5dfb5f0a5d4251bd5f3ec556ef1c5a0687e3ee6"
  license "MIT"
  head "https://github.com/tj/n.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "02e08248144bde702ee5e229fd151f48bf940cca39eabf1942d939b5c7b1f083"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "02e08248144bde702ee5e229fd151f48bf940cca39eabf1942d939b5c7b1f083"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02e08248144bde702ee5e229fd151f48bf940cca39eabf1942d939b5c7b1f083"
    sha256 cellar: :any_skip_relocation, sonoma:         "9b1405408135e3dfd8f2b44b10c841fdb7dba5396d0697b6cd61d8b9549df740"
    sha256 cellar: :any_skip_relocation, ventura:        "9b1405408135e3dfd8f2b44b10c841fdb7dba5396d0697b6cd61d8b9549df740"
    sha256 cellar: :any_skip_relocation, monterey:       "9b1405408135e3dfd8f2b44b10c841fdb7dba5396d0697b6cd61d8b9549df740"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02e08248144bde702ee5e229fd151f48bf940cca39eabf1942d939b5c7b1f083"
  end

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"n", "ls"
  end
end
