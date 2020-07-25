class Clib < Formula
  desc "Package manager for C programming"
  homepage "https://github.com/clibs/clib"
  url "https://github.com/clibs/clib/archive/2.1.8.tar.gz"
  sha256 "ce51dbf4176549ee63d5e221fbbab5acf539a89f9a3cbe54614c72e6811e0538"
  license "MIT"
  head "https://github.com/clibs/clib.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "942cae79d44b57379446af71700ceb1beab3cf880bf3bf7c325fd33f80f22add" => :catalina
    sha256 "49d50ea654bc428fd15e46327f2f730fcea3e50a82d93f294fe66147b3c57a6c" => :mojave
    sha256 "3374324a5e7dd723ce66e4eae01fb16218f1ec601d83927c55aebfaf78ddbb46" => :high_sierra
  end

  uses_from_macos "curl"

  def install
    ENV["PREFIX"] = prefix
    system "make", "install"
  end

  test do
    system "#{bin}/clib", "install", "stephenmathieson/rot13.c"
  end
end
