class Aliyunpan < Formula
  desc "Command-line client tool for Alibaba aDrive disk"
  homepage "https://github.com/tickstep/aliyunpan"
  url "https://github.com/tickstep/aliyunpan/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "161b48b7e5c62c0d4ad3da4b90cee5d103f3ef245176dcc4cd7fb1e5e00c88f9"
  license "Apache-2.0"
  head "https://github.com/tickstep/aliyunpan.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f19a4e8d305b59bba551184cca5d4f9cc33818f26f30309659186e4e3bb1e973"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef3ed0962b3a98676e9632339586980abd79794293f519f0f5694cca06808e9b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06969a084b1bccf2c8d52f7c457607cfbb74ff9a019c9f2aa65ebc7c0180f8f2"
    sha256 cellar: :any_skip_relocation, sonoma:         "16e20dbb9279db281dc9f58fa3d7fc427c8dd18a9cd59e45b526b769e60277d4"
    sha256 cellar: :any_skip_relocation, ventura:        "45af3a65a317a8519c8c3753ba1eb93e5d926e637892ecf67e6a9fc7e8e30549"
    sha256 cellar: :any_skip_relocation, monterey:       "f77112f1d378a1f2972438952b2f863ac270b297fd46f9aae14e51364f2ca57e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0addd9c7eaf498b0cc11a6b0d96a94c3a35b94b41223a1257c4d578bdbf8309"
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
