class Muffet < Formula
  desc "Fast website link checker in Go"
  homepage "https://github.com/raviqqe/muffet"
  url "https://github.com/raviqqe/muffet/archive/v2.4.8.tar.gz"
  sha256 "82277a99a854fbf5dc84ac0a7eb2f43e46b93d690a121ae972ec07f7879b5585"
  license "MIT"
  head "https://github.com/raviqqe/muffet.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5696204d9656e0d954125b8631bb6b95c67a1c9553591a377bf126d55e3a2992"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cc861adf5a58fe8a99b03e1aa53fcbb6c66e43e99b526bcb395b9d35941ed817"
    sha256 cellar: :any_skip_relocation, monterey:       "dffe8db2000f0e4ad66b4537627c881324e90e6ecbba5403b9bf5072c9f74004"
    sha256 cellar: :any_skip_relocation, big_sur:        "bc82c30d46d35db05a249eee1073f6776d848f8129386ad2980afab0e4af4f6a"
    sha256 cellar: :any_skip_relocation, catalina:       "fa6d35eee44644b9ae7cd18839e9d37ca44367278afab274c7e4943a8ca4deb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16ac5ec90441ee2664e5e5b65b867f3cb530d078b52f62f74d6710ab9543ff4c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match(/failed to fetch root page: lookup does\.not\.exist.*: no such host/,
                 shell_output("#{bin}/muffet https://does.not.exist 2>&1", 1))

    assert_match "https://httpbin.org/",
                 shell_output("#{bin}/muffet https://httpbin.org 2>&1", 1)
  end
end
