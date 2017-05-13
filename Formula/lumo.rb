class Lumo < Formula
  desc "Fast, cross-platform, standalone ClojureScript REPL"
  homepage "https://github.com/anmonteiro/lumo"
  url "https://github.com/anmonteiro/lumo/archive/1.4.1.tar.gz"
  sha256 "916bc18ab732ab617b6d99e40ec839731bab4527eeeafb5aae4e232f67ad1052"
  head "https://github.com/anmonteiro/lumo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dc1411a08482a622f5c8d5efb31b25490643e4d9e9a80278096909dc2ca3ef91" => :sierra
    sha256 "68190567e18030f252242be5f0e09fe70597f714b2149516318a60aff2220302" => :el_capitan
    sha256 "ded3d6ff6360dbca4ab18c17dae23d0569eb492a0d9d4f774f843f2822047c68" => :yosemite
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
