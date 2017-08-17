class Lumo < Formula
  desc "Fast, cross-platform, standalone ClojureScript environment"
  homepage "https://github.com/anmonteiro/lumo"
  url "https://github.com/anmonteiro/lumo/archive/1.7.0.tar.gz"
  sha256 "c5b37815d41581974dd026f2f02389102c4af4934c87e15d4c3c1d85f3211e1e"
  head "https://github.com/anmonteiro/lumo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5c6adf7ea74408d00f8bd64f96d2f91c19ed654e082c64062f772297e1e8d405" => :sierra
    sha256 "f76069e48afc5a4d37c320ed7aa92a0a5ca4e139e2b6f3e67ac053caeb1941f8" => :el_capitan
    sha256 "6a380a90dbfc91162d21c9ceb5ff9d2891ecff0c701840cc7c1758b48235633f" => :yosemite
  end

  depends_on "boot-clj" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    ENV["BOOT_HOME"] = "#{buildpath}/.boot"
    ENV["BOOT_LOCAL_REPO"] = "#{buildpath}/.m2/repository"
    system "boot", "release-ci"
    bin.install "build/lumo"
  end

  test do
    assert_equal "0", shell_output("#{bin}/lumo -e '(- 1 1)'").chomp
  end
end
