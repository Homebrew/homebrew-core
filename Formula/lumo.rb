class Lumo < Formula
  desc "Fast, cross-platform, standalone ClojureScript environment"
  homepage "https://github.com/anmonteiro/lumo"
  url "https://github.com/anmonteiro/lumo/archive/1.9.0.tar.gz"
  sha256 "fc71a6a0b6ce928b3af93f1a119b6920d8bf6bbde1ed5f873f1bda4fb5fc23d7"
  head "https://github.com/anmonteiro/lumo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bfcb83afc1be4e03da673003e70a80ee87994f88fb31b1a8aa667188815b4cde" => :mojave
    sha256 "a6fd1d1bbcf42f4f59ba2b94b0c44326fad9847d786be7a7ca6cfcfd06d0d723" => :high_sierra
    sha256 "6b89ef087a38b26840b41a2d6c8046d5fa4f8f2e895693cce8acc9b57d73e161" => :sierra
    sha256 "df519f90ebaef9a163ea6816695a3868d205530eec4809162c661458cd2004dc" => :el_capitan
  end

  depends_on "boot-clj" => :build
  depends_on :java => ["1.8", :build]
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
