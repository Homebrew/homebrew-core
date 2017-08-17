class Lumo < Formula
  desc "Fast, cross-platform, standalone ClojureScript environment"
  homepage "https://github.com/anmonteiro/lumo"
  url "https://github.com/anmonteiro/lumo/archive/1.7.0.tar.gz"
  sha256 "c5b37815d41581974dd026f2f02389102c4af4934c87e15d4c3c1d85f3211e1e"
  head "https://github.com/anmonteiro/lumo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f99d3b8cbd2fe4bd10f691477b353c5fc4acd430f441c086b46d1559969668c9" => :sierra
    sha256 "27e79277bf35a0cfc401f2ba925f6ae914157522e6315a2cf4bae1af6244c4b2" => :el_capitan
    sha256 "72dc7ea30baecd347ee8ebaa3cb822a4337088e02efd2dd5b4e6e62b38bf0dca" => :yosemite
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
