class Gitql < Formula
  desc "Git query language"
  homepage "https://github.com/filhodanuvem/gitql"
  url "https://github.com/filhodanuvem/gitql/archive/2.2.0.tar.gz"
  sha256 "89bfbb41f85eaab5f6644a9750906e9c021738cbf3578119086448857cb65892"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "427cb6ac84a8d1983f73d4a458bf230df92c6f8b3974098dbaf1ac5050db1dc9"
    sha256 cellar: :any_skip_relocation, big_sur:       "9472cb84f1432a24026e7712b711dd999728a32fc68b26f5497d6bf80555d3bd"
    sha256 cellar: :any_skip_relocation, catalina:      "c3f6e4b207216305720a093d617b9ca8d19635ad9bb452ca027e378b23caa1bc"
    sha256 cellar: :any_skip_relocation, mojave:        "7caa91b30df4de83ac06abaf0d5fd24be32b118deadbc1f10d82eb1bc624a73a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    system "git", "init"
    assert_match "author", shell_output("#{bin}/gitql 'SELECT * FROM commits'")
  end
end
