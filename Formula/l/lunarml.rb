class Lunarml < Formula
  desc "Standard ML compiler that produces Lua/JavaScript"
  homepage "https://github.com/minoki/LunarML"
  url "https://github.com/minoki/LunarML/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "459719f7b462ae3bb1485d2055fe9a62bdd1bc91f569cfd0480757c48054d8ee"
  license "MIT"
  head "https://github.com/minoki/LunarML.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2df11728ca3fb49958d60145918c3dba582f0d87c1491bcfd9c2f8407cf241f8"
    sha256 cellar: :any,                 arm64_sequoia: "7750dd7c517dbbb3b0ab429db707b9c804ed7686a859c98f1430f0c086886123"
    sha256 cellar: :any,                 arm64_sonoma:  "bdbc062f5d379d8611977746b014f9984b3b68f76188b3ab752e37b512e54cca"
    sha256 cellar: :any,                 sonoma:        "030100cb16de338080fd919a41f4048e90ef9d692209950feefe052ccdab0972"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0dbe810a70d79fb20e22676a8ca6112e83f46755704d38e3ca6c1d720490faf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afc712f980e20f4c0d9ddc3222ad101737c55c0baae2d394564510349c4bbf11"
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
