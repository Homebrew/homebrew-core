class Lumo < Formula
  desc "Fast, cross-platform, standalone ClojureScript REPL"
  homepage "https://github.com/anmonteiro/lumo"
  url "https://github.com/anmonteiro/lumo/archive/1.1.0.tar.gz"
  sha256 "03bf4b80ea2163c26c584fc80fe28de250e553c4443b58ddf489749fa8da0249"
  head "https://github.com/anmonteiro/lumo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3e9852b8ca3e68827bcd900e2738fdae8f8bab492888e3a56a9b84f8bb5d54ce" => :sierra
    sha256 "3f2a04bcd3c4d8bc59b9e13c1693626c6d78843c177bde6aef1c142a4cf98bb8" => :el_capitan
    sha256 "0aa3268d1944247a7634d8b0e3902d473e53de23867d66eff9cc2f784f543425" => :yosemite
  end

  depends_on "boot-clj" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    ENV["BOOT_HOME"] = "#{buildpath}/.boot"
    ENV["BOOT_LOCAL_REPO"] = "#{buildpath}/.m2/repository"
    system "boot", "release"
    bin.install "build/lumo"
  end

  test do
    assert_equal "0", shell_output("#{bin}/lumo -e '(- 1 1)'").chomp
  end
end
