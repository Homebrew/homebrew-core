class Lbdb < Formula
  desc "Little brother's database for the mutt mail reader"
  homepage "https://www.spinnaker.de/lbdb/"
  url "https://www.spinnaker.de/lbdb/download/lbdb_0.49.1.tar.gz"
  sha256 "e2a57a2935d52ae5fbcc76d84ee06955d943c4696d0b43c7c1de5b8bc7f0f31e"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.spinnaker.de/lbdb/download/"
    regex(/href=.*?lbdb[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e087de084cff07eae814fc954fa74a74d73b0f06d0f91129977112d6558ecbac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6c8daad11d118ab04bb0209f95c9c828392a5b260eaee63dbe73a7b5f30b8ba8"
    sha256 cellar: :any_skip_relocation, monterey:       "41cdd85f7474a49f24cee7c69a7d5108c4ea24fb766674112415eb1b42659a0a"
    sha256 cellar: :any_skip_relocation, big_sur:        "d95cc4ac68303be926a5c9ca8a4a17bbc545f3ce02ce345ecebe95a613ed5484"
    sha256 cellar: :any_skip_relocation, catalina:       "3eafefa5553d8660c6d315f15f6bb963b7e21673b485ad681a2b8e2c3c9aeb13"
    sha256 cellar: :any_skip_relocation, mojave:         "d8292aef28eecf34b970aba54f473dfa88cd5c64b9415002e1a62ae1e2dc393c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "482715f9ab4a754a6425a34380b0388f51eff44c73b45ed1bec356566173050a"
  end

  depends_on "abook"

  def install
    system "./configure", "--prefix=#{prefix}", "--libdir=#{lib}/lbdb"
    system "make", "install"
  end

  test do
    assert_match version.major_minor.to_s, shell_output("#{bin}/lbdbq -v")
  end
end
