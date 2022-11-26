class Page < Formula
  desc "Use Neovim as pager"
  homepage "https://github.com/I60R/page"
  url "https://github.com/I60R/page/archive/refs/tags/v4.1.0.tar.gz"
  sha256 "3895384b6af87db55133222b86e83a6187c300fa7c7d79aed64e2450b641f9de"
  license "MIT"
  head "https://github.com/I60R/page.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df4cae290539e646ddb4e62a8a960bee9d5091b8150953f14584e9bf89dbb9f6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cfbbfa9a8fc94ab72873581413b1f4ba5780de3b93a39c6127246112c20a6f53"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "669f84cd2f3bcca9c5bdd41034167f0945efda5045d817efcb5067ad09c1daea"
    sha256 cellar: :any_skip_relocation, ventura:        "7b78f47b6340f5b51cadd6f2b8d25051fa8ab5a9d59865f803f86b7ab6097c72"
    sha256 cellar: :any_skip_relocation, monterey:       "71f4fa8a352edc9a2a43df532e37fe9c5b3bd7dd98fc70c7f12e3ea013a88c89"
    sha256 cellar: :any_skip_relocation, big_sur:        "f265e404a083079103c6bc00e7aa811c8a8b2576dd67f1468b62f7ac78160f87"
    sha256 cellar: :any_skip_relocation, catalina:       "b4969223548fb851d27e3f5a8643b44f6012dc52f2ded74d0ebe32d103969b33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01ae56c67892c13654670acafa8c2219658babedeec0eae31af7767032ce9cc8"
  end

  depends_on "rust" => :build
  depends_on "neovim"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    text = "test"
    assert_match text, pipe_output("#{bin}/page -O 1", text)
  end
end
