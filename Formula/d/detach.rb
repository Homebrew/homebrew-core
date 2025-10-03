class Detach < Formula
  desc "Execute given command in detached process"
  homepage "http://inglorion.net/software/detach/"
  url "http://inglorion.net/download/detach-0.2.3.tar.bz2"
  sha256 "b2070e708d4fe3a84197e2a68f25e477dba3c2d8b1f9ce568f70fc8b8e8a30f0"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?detach[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "26af0691540557a38f48cea373f6a0a9085bf2ba7a71bfcb7aa67e844ce3f466"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f7d0f80127112fcf6691ce7b4b90aa1fc5ee9ddee51d755b1a895f47419f2455"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c5ad00a2d77cb8c391aea1df731916286b2a9758b6948397e4943f10baec5269"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "43dbfbe7fe5ea211f28aff3bd251dad03ddb486ff8230bc35084b0c8111a0058"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f208e16128573ea8b839c8fe27a6f23e72dcf99064f088e4d552aec5358cf54f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "934338f4dbae7773162dfa2a6b83d3c72a0740747bd4494509a9d5ee20bf37b5"
    sha256 cellar: :any_skip_relocation, sonoma:         "32f4187991a03c5192da3a66e0c7d109f17a349848124cd38b782ca7dfa14e37"
    sha256 cellar: :any_skip_relocation, ventura:        "94bd75041180a9e7cf48d3c352d2ef788a3f9ca382a77ecc1195b221c375b99c"
    sha256 cellar: :any_skip_relocation, monterey:       "469c22339c28e7497bead225e1597d5ae4ccadd2589e355be65041bd2c2ac5c9"
    sha256 cellar: :any_skip_relocation, big_sur:        "9db6ee661710f178b17fc1096596ee74b07b257e233da7fb45cb9280cbeb24a1"
    sha256 cellar: :any_skip_relocation, catalina:       "dbd06a1dcb4592035dff0b4df0cc3259c2dbb444acdb1553ab2a2d4edf3fff57"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "8fba912efb0e2473b0c089087b8a7239fbf21952e15fa541b41d8542f2277d96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38838383187537acd5cd6c52ea5d375055201ad74494107a5150ac684374028d"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
    bin.install "detach"
    man1.install "detach.1"
  end

  test do
    system bin/"detach", "-p", "#{testpath}/pid", "sh", "-c", "sleep 10"
    pid = (testpath/"pid").read.to_i
    ppid = shell_output("ps -p #{pid} -o ppid=").to_i
    assert_equal 1, ppid
    Process.kill "TERM", pid
  end
end
