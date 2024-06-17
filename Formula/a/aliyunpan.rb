class Aliyunpan < Formula
  desc "Command-line client tool for Alibaba aDrive disk"
  homepage "https://github.com/tickstep/aliyunpan"
  url "https://github.com/tickstep/aliyunpan/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "d47ba49da29c831509883585df9683c2557debba077edb8114188c258349a0b9"
  license "Apache-2.0"
  head "https://github.com/tickstep/aliyunpan.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7586081a844bbb72a15cf21784e6beeae9fff16e65a2b8efc28f6039341a165d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "58b05384c438b32391594f947ab8d7b34dbc33b90f71889256b8b26d982b0730"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53dea5c0d8e8f561c5bb30b434e7c378ec93e370307bb68b589120e63134f668"
    sha256 cellar: :any_skip_relocation, sonoma:         "0fc1820ecce9f3ef510e9bde7b985629d39620e854cc118156e76c29e5247c77"
    sha256 cellar: :any_skip_relocation, ventura:        "c8b333807ee8312e467388f30fc2d724b8f189bb5d260f1c5118255419ebb4ea"
    sha256 cellar: :any_skip_relocation, monterey:       "0cb67308bea17af873a5345126137c66c6408264b6567729f398c61e6c8bf6fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cce09c84f4d2f1693945d82ab873d0a419913a8bfc3b87d4acd160803abe76b1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"aliyunpan", "run", "touch", "output.txt"
    assert_predicate testpath/"output.txt", :exist?
  end
end
