class Lumo < Formula
  desc "Fast, cross-platform, standalone ClojureScript REPL"
  homepage "https://github.com/anmonteiro/lumo"
  url "https://github.com/anmonteiro/lumo/archive/1.3.0.tar.gz"
  sha256 "01bf17bbb85f515b1ae45d8ebce01ba71481123a69273382c32aa69cf7867f56"
  head "https://github.com/anmonteiro/lumo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "88c901dd6c85580ee82be4da0098699e58e9a50ca770ef7aed903bbfd2c0d743" => :sierra
    sha256 "1d3daaca82da8931128ec2157bf36f4ca9da1a82602310e2519a40e823c514b9" => :el_capitan
    sha256 "d4cf229c693a4e729d7febf26e5172439ba634110210bf44cc75efdb2a8a1e52" => :yosemite
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
