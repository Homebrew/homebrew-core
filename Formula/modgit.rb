class Modgit < Formula
  desc "Tool for git repo deploy with filters. Used for magento development"
  homepage "https://github.com/jreinke/modgit"
  url "https://github.com/jreinke/modgit/archive/v1.1.0.tar.gz"
  sha256 "9d279c370eee29f54017ca20cf543efda87534bd6a584e7c0f489bbf931dccb8"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0428f040a4b3f361834936dfc098f2ba08f979b81d9b6fc6b7cf6b401e5c308a"
  end

  def install
    bin.install "modgit"
  end

  test do
    system "#{bin}/modgit"
  end
end
