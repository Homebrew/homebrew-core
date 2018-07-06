class HaskellIdeEngine < Formula
  desc "The IDE engine and LSP server for Haskell. Not an IDE"
  homepage "https://github.com/haskell/haskell-ide-engine"

  url "https://github.com/haskell/haskell-ide-engine.git",
      :revision => "8e0b60f3d47f6332c0f4415b9fff03815e229275"

  version "0.1.0.0"
  sha256 "e2195fc6bf01e4b9509e7be388e53fb4e0103658a3f26aca997b54cdd52273dd"

  depends_on "haskell-stack" => :build

  def install
    ENV.deparallelize
    system "make", "build-all"
    bin.install Dir[".brew_home/.local/bin/*"]
  end

  test do
    system "#{bin}/hie", "--version"
    system "#{bin}/hie-wrapper", "--version"
  end
end
