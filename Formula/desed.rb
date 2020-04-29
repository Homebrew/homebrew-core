class Desed < Formula
  desc "Demystify and debug your sed scripts, from comfort of your terminal"
  homepage "https://soptik.tech/articles/building-desed-the-sed-debugger.html"
  url "https://github.com/SoptikHa2/desed/archive/v1.1.4.tar.gz"
  sha256 "077984eb2aa5466982c43da4fb20db7ea5e9d5a2701efe93f14d0b3e8b47e71a"
  head "https://github.com/SoptikHa2/desed.git"

  depends_on "rust" => :build
  depends_on "gnu-sed"

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    # package contains just an executable that spawns a TUI
    assert_predicate bin/"desed", :exist?
  end
end
