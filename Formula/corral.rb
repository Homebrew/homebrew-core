class Corral < Formula
  desc "Dependency manager for the Pony language"
  homepage "https://github.com/ponylang/corral"
  url "https://github.com/ponylang/corral/archive/0.5.7.tar.gz"
  sha256 "5b7cffc54abe5b2292a2fb2c67603a52c0c02d38ab8bbd2af2af0b80ca62e414"
  license "BSD-2-Clause"
  head "https://github.com/ponylang/corral.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0686d038672fa53840d27dfd661a7c013a93eb97ce76128e4a72321392dc14fe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "30aa4c949fd82b68a86be425b9960e0f34d7d9ed88c893be90ef44062c6482a1"
    sha256 cellar: :any_skip_relocation, monterey:       "386d7d7ba90d915aac87e2d5d9b7b591beb29303f484fca68c9c583981cbbaf2"
    sha256 cellar: :any_skip_relocation, big_sur:        "a8d1119dce9ebcd488c79b9771a7c83858e88733ba70619aa2762fae96b226c9"
    sha256 cellar: :any_skip_relocation, catalina:       "f75e543d17a1855c87df8a71343c9353aa4acb1e4c9d765134d3b256eca4a286"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59dfb4a4c76b0feec7726eb395eb312b308737702ac4b071d33704ffa0eff2f8"
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
