class Corral < Formula
  desc "Dependency manager for the Pony language"
  homepage "https://github.com/ponylang/corral"
  url "https://github.com/ponylang/corral/archive/refs/tags/0.9.2.tar.gz"
  sha256 "c6b0000fe2f5c451923988e2fc44da3f2a3c37dd35f2125239028edebdb408b5"
  license "BSD-2-Clause"
  head "https://github.com/ponylang/corral.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f3de1320410cb39bc11d33df5cad6e582d890625cd335e86cb7989d0a386f68"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a562e1fe2715cef547ce09cf263d19b07b8bb20264a90b1a49782eed5e8ff4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4273e435e4df08d17fb7607379c1d978e76d8af4e7e83c57abe3a99d328abc5"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e715fac5e78e7b91e8e5f7ad998aac7133a8ab8197b2f6cd4f40cf547b89d4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e91957a9613d01dcf70d745a9ee58142e325573b9ac051351796e669efa1b0fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10b3afde7155d1a4ce99cd9e25442fd8cfa52052cc1abfc24469e99fd1f077e2"
  end

  depends_on "ponyc"

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    (testpath/"test/main.pony").write <<~PONY
      actor Main
        new create(env: Env) =>
          env.out.print("Hello World!")
    PONY
    system bin/"corral", "run", "--", "ponyc", "test"
    assert_equal "Hello World!", shell_output("./test1").chomp
  end
end
