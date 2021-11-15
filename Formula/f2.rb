class F2 < Formula
  desc "Command-line batch renaming tool"
  homepage "https://github.com/ayoisaiah/f2"
  url "https://github.com/ayoisaiah/f2/archive/v1.7.2.tar.gz"
  sha256 "5c44d9d7bbd428e7c0d1a37118fbfec47b38dbb708501a2b3adc4f4da3e049ef"
  license "MIT"
  head "https://github.com/ayoisaiah/f2.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a3dc629d4f01d36ed2df71e6bf830123533cdf1c23e0593fd76f0f5878f07683"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0168bda1dc02db458cb14dbf31444f1f1d054e9fb53c42d660cecd7c4b240d4d"
    sha256 cellar: :any_skip_relocation, monterey:       "69dbf8f56829c1da8b51ea3582d09bd1164bce5c9dc0aa4156ad457a2b3a3d04"
    sha256 cellar: :any_skip_relocation, big_sur:        "26de580bdc9278b69835aab94c978bfc0bd0de551f1f3157423e06fe6d5a9a13"
    sha256 cellar: :any_skip_relocation, catalina:       "4f6022ae8ec91b6bb2e9536e01f159ac9e92b0fe803f9888d55eefa147e3d626"
    sha256 cellar: :any_skip_relocation, mojave:         "10fdc45834b4bd953d28c76d9c453d4136231d3f777ff5c272099dffe83a041d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afd86cec56fa3b8469b20dc725131f20b2edc39b2ec93f21bdd3198a46f9b7d5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd..."
  end

  test do
    touch "test1-foo.foo"
    touch "test2-foo.foo"
    system bin/"f2", "-s", "-f", ".foo", "-r", ".bar", "-x"
    assert_predicate testpath/"test1-foo.bar", :exist?
    assert_predicate testpath/"test2-foo.bar", :exist?
    refute_predicate testpath/"test1-foo.foo", :exist?
    refute_predicate testpath/"test2-foo.foo", :exist?
  end
end
