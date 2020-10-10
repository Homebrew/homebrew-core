class Inform6 < Formula
  desc "Design system for interactive fiction"
  homepage "https://inform-fiction.org/inform6.html"
  url "https://ifarchive.org/if-archive/infocom/compilers/inform6/source/inform-6.34-6.12.4-1.tar.gz"
  mirror "https://ifarchive.org/if-archive/infocom/compilers/inform6/source/old/inform-6.34-6.12.4-1.tar.gz"
  version "6.34-6.12.4-1"
  sha256 "8cc1983c7bbed7f23fcf3cd549fe8dc10b1a506b95129c35e9f61d2e79b85295"
  head "https://gitlab.com/DavidGriffith/inform6unix.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "961725b635b0a0bec6c5ee2de80485cc2ae54c6704692095bf73afb45d4934a0" => :catalina
    sha256 "be06ad010ef37eb03a5ec804cd6547087772350ccc1c03d6854cd4bebd8a5b9d" => :mojave
    sha256 "087ee415674833ac532a1fe70c30d8d84015d91e1eeab76273707e7754ef8be4" => :high_sierra
  end

  resource "Adventureland.inf" do
    url "https://inform-fiction.org/examples/Adventureland/Adventureland.inf"
    sha256 "3961388ff00b5dfd1ccc1bb0d2a5c01a44af99bdcf763868979fa43ba3393ae7"
  end

  def install
    system "make", "PREFIX=#{prefix}", "MAN_PREFIX=#{man}", "install"
  end

  test do
    resource("Adventureland.inf").stage do
      system "#{bin}/inform", "Adventureland.inf"
      assert_predicate Pathname.pwd/"Adventureland.z5", :exist?
    end
  end
end
