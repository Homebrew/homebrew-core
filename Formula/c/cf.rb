class Cf < Formula
  desc "Filter to replace numeric timestamps with a formatted date time"
  homepage "https://ee.lbl.gov/"
  url "https://ee.lbl.gov/downloads/cf/cf-1.2.7.tar.gz"
  sha256 "cdb8d7aa1c45f2baa4b3c2b355ab8653a8a4b222fce6d9092edb4c3a98fef081"
  license "BSD-3-Clause"

  livecheck do
    url "https://ee.lbl.gov/downloads/cf/"
    regex(/href=.*?cf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a48fe3aae85ac626f6fa80508c4a9b1623fa4b134ce9a34a6d98880ff718d78f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "71b36856f3b6cf08b642489b4e84cd1f809f24557ef1378256ffb536035748d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6aea6b45b8b308b818eebd925c4cf452e5b50be2f8795c3d77b0ddf83b264ea0"
    sha256 cellar: :any_skip_relocation, sonoma:         "1a1e0f3bf50ce389b175411b08f6e247a96a73e83c692b63c37f1fa4b96ed5c9"
    sha256 cellar: :any_skip_relocation, ventura:        "1b5ae0887650b078377a36d0fd1d4b8a1aee5899942e27d5107ea383c8cc3da9"
    sha256 cellar: :any_skip_relocation, monterey:       "82f5e7d6ff9d78aab2d967d95aaecc3296c1801b88f763a2d4bb3aeb416122de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b10af174bf2bacdbf06c9b64c649740cb78ede8135aa400ede6c78a26af74ef"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    bin.mkpath
    man1.mkpath
    system "make", "install"
    system "make", "install-man"
  end

  test do
    assert_match "Jan 20 00:35:44", pipe_output("#{bin}/cf -u", "1074558944")
  end
end
