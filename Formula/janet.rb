class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://github.com/janet-lang/janet/archive/v1.18.0.tar.gz"
  sha256 "f2d751b3b6e1a1712aae0f639be7a76764469303a55ae5d8881d6535dbe3bd0e"
  license "MIT"
  head "https://github.com/janet-lang/janet.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "9cc2c969ff61436196c29c948bd33eca4210f73f8bc9a59e4d98e403412ba454"
    sha256 cellar: :any,                 big_sur:       "7640e528a44148da17c001f44dd354543926cf4f7499ad6c9922b25d1f75dd3e"
    sha256 cellar: :any,                 catalina:      "91a88d185780354a339b6a213bdf4815e3193360d9259d538a9562b1d20fcc88"
    sha256 cellar: :any,                 mojave:        "8f0fa7efbe18e4ccf1142a91f1649744b7dfe2d8180d7433d1684f1c95858853"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a70e2d4774a97380ac917ee9c104b76a03740892cd1776dc028994ce09795ea9"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    system "meson", "setup", "build", *std_meson_args
    cd "build" do
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    assert_equal "12", shell_output("#{bin}/janet -e '(print (+ 5 7))'").strip
  end
end
