class Lunarml < Formula
  desc "Standard ML compiler that produces Lua/JavaScript"
  homepage "https://github.com/minoki/LunarML"
  url "https://github.com/minoki/LunarML/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "f4efce99a17f2f7a479d0ab9d858d1c79624ddaba85f8bc08c06e186fd57ed9e"
  license "MIT"
  head "https://github.com/minoki/LunarML.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "99d7c42200ec770420de1ee83f8e2a2948510dc5585df1eb3a7fa3a8c4952224"
    sha256 cellar: :any,                 arm64_sonoma:  "8ce3a6d12a55a1977c4c39491f52742814da9dd6b1d007271c81d666ef62c912"
    sha256 cellar: :any,                 arm64_ventura: "b9e15d9780dc25de4e2fd6292365fad7aae3e0250b2ee15e7fbcc827e861ffdf"
    sha256 cellar: :any,                 sonoma:        "bfe37be13b868f9cc63813d9fed1fe3018e291816f45ba8eaf5c59876b36fb2c"
    sha256 cellar: :any,                 ventura:       "95588395c2dcfa6363cc5e5d9c2fa8d1241cdc85a2e47baddce0e4cb4b1dd9b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63f392dc71b8c035f4e078aa4b7ca0e15ad1a7e20145a2769a3d1ec29aa243e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e0c9969d0590e2023d69b3ff8a4cfcad0392ce07aafe299882648b76373c43c"
  end

  depends_on "mlton" => :build
  depends_on "lua" => :test
  depends_on "node" => :test
  depends_on "gmp"

  def install
    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lunarml --version 2>&1")

    (testpath/"factorial.sml").write <<~SML
      val rec factorial = fn n => if n = 0 orelse n = 1 then
              1
          else
              n * factorial (n - 1);

      print (Int.toString (factorial 10) ^ "\n");
    SML
    system bin/"lunarml", "compile", "--lua", "factorial.sml"
    system bin/"lunarml", "compile", "--nodejs", "factorial.sml"

    assert_equal "3628800", shell_output("#{Formula["lua"].opt_bin}/lua factorial.lua").chomp
    assert_equal "3628800", shell_output("#{Formula["node"].opt_bin}/node factorial.mjs").chomp
  end
end
