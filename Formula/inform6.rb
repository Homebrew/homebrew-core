class Inform6 < Formula
  desc "Design system for interactive fiction"
  homepage "https://inform-fiction.org/inform6.html"
  url "https://ifarchive.org/if-archive/infocom/compilers/inform6/source/old/inform-6.33-6.12.1.tar.gz"
  version "6.33-6.12.1"
  sha256 "9170d6a0283aa65e1205621e89f78d674c8df978ee9c0b1c67f8b1aea4722a77"
  revision 1
  head "https://gitlab.com/DavidGriffith/inform6unix.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "451af7c99925f78d66fff29b745b6607710b3e03282ba498a82277d00cd49d9c" => :catalina
    sha256 "b423cc4b764b8ffda3d2f95aa2ec0a1f917455ca7fbb2969dd6aecdf818ed3c5" => :mojave
    sha256 "0755c9d4c5994a6f4ebe4c74f8bb1e93665de66ae65c89c85120396edc85550d" => :high_sierra
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
