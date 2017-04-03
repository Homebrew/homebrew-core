class Lumo < Formula
  desc "Fast, cross-platform, standalone ClojureScript REPL"
  homepage "https://github.com/anmonteiro/lumo"
  url "https://github.com/anmonteiro/lumo/archive/1.3.0.tar.gz"
  sha256 "01bf17bbb85f515b1ae45d8ebce01ba71481123a69273382c32aa69cf7867f56"
  head "https://github.com/anmonteiro/lumo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b3e7944aeb12061c523bdb16761c4e3155fc9ba461e14c5bdd36021646e4e979" => :sierra
    sha256 "76d01172eabd9b00a2a556dcc5a272ea70f945590c3e179cd0ae68d0d1455621" => :el_capitan
    sha256 "d398aaf771ef1b5676f84b729ca3d511d6265648b62eaf99b454425a2b0c7dbb" => :yosemite
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
