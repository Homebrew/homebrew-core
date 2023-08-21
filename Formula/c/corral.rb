class Corral < Formula
  desc "Dependency manager for the Pony language"
  homepage "https://github.com/ponylang/corral"
  url "https://github.com/ponylang/corral/archive/0.7.0.tar.gz"
  sha256 "871de010677666fbe39a22e387e261f2b501af0c69f47bf98b40495162f443e5"
  license "BSD-2-Clause"
  head "https://github.com/ponylang/corral.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "08b240c9a36bb553b8697392964287e6d74f5a72130ce4e9ef4169231c9296ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc0e848c7e2d50bce82b7d972e938b6830b7f086ea34c8add0a7dffcaff7dace"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "480e8bc1a131f893a29b5c00db1be653da668bd982455eb8652de5dd04efcca0"
    sha256 cellar: :any_skip_relocation, ventura:        "fa41d7e2f0b025cbe41c905eb692161034ac56aa5a672b9327a9db75928a22ea"
    sha256 cellar: :any_skip_relocation, monterey:       "81874157b1e52b3b1a2ec1ebcc367f436d771619a3f41f0ac1646fbaa915f1e7"
    sha256 cellar: :any_skip_relocation, big_sur:        "d675a204fa4b237e2996c71ee3849559e46369fb728cd37ff1efb537e750aa5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29e9b75c76c14dfe35a46dbe0d2b02c7d32259f344b8001fd35843723c7c9dc0"
  end

  depends_on "ponyc"

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    (testpath/"test/main.pony").write <<~EOS
      actor Main
        new create(env: Env) =>
          env.out.print("Hello World!")
    EOS
    system "#{bin}/corral", "run", "--", "ponyc", "test"
    assert_equal "Hello World!", shell_output("./test1").chomp
  end
end
