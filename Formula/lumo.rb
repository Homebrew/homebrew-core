class Lumo < Formula
  desc "Fast, cross-platform, standalone ClojureScript REPL"
  homepage "https://github.com/anmonteiro/lumo"
  url "https://github.com/anmonteiro/lumo/archive/1.4.0.tar.gz"
  sha256 "7c5bfde6820c93bba65b8798e75d4d83b36919bcad8280c8f4f799a2266c7737"
  head "https://github.com/anmonteiro/lumo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7eaf574fc80ef59474f4e7a23a06ed7fdcee15ebc5ed2ea74a5e1aaace867c78" => :sierra
    sha256 "aee73aafc1d1b620a14b4c6fc8c7ace3b523c8e36a4a047694ce89b222539e1f" => :el_capitan
    sha256 "8fcf053c69cbb1af2b8cbe4623bb495737d65311344a3e133356c9de85b31576" => :yosemite
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
