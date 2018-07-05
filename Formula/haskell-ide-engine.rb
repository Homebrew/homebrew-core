class HaskellIdeEngine < Formula
  desc "The IDE engine and LSP server for Haskell. Not an IDE"
  homepage "https://github.com/haskell/haskell-ide-engine"

  url "https://github.com/haskell/haskell-ide-engine.git",
      :revision => "8e0b60f3d47f6332c0f4415b9fff03815e229275"

  version "0.1.0.0"
  sha256 "e2195fc6bf01e4b9509e7be388e53fb4e0103658a3f26aca997b54cdd52273dd"

  head "https://github.com/alanz/haskell-ide-engine.git"

  option "without-hoogle", "Don't generate Hoogle documentation"

  depends_on "haskell-stack" => :build
  depends_on "icu4c" => :build # Needed for the text-icu cabal package

  def install
    ENV.deparallelize
    if build.without? "hoogle"
      system "make", "build"
    else
      system "make", "build-all"
    end
    bin.install Dir[".brew_home/.local/bin/*"]
  end

  test do
    system "#{bin}/hie", "--version"
    system "#{bin}/hie-wrapper", "--version"
  end
end
