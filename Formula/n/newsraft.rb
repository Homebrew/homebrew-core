class Newsraft < Formula
  desc "Terminal feed reader"
  homepage "https://codeberg.org/newsraft/newsraft"
  url "https://codeberg.org/newsraft/newsraft/archive/newsraft-0.35.tar.gz"
  sha256 "6a87c8a9b8556650d18443baf827cf930aa4a5c5361a36397b95f275e28d540d"
  license "ISC"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3359d9c4fe6e8c481cb183cbf285db4dd79de23b3a62b3aaede24949673ec4a6"
    sha256 cellar: :any,                 arm64_sequoia: "8a85c664f289e94a188da97781a5f8368a2d449086259ca9e2e24b5a44f9be5e"
    sha256 cellar: :any,                 arm64_sonoma:  "f9f4da93f3a9b7cb74b657fb6b415c4f20b6c2d63745a145f5743f820159e0e6"
    sha256 cellar: :any,                 sonoma:        "5099cad517f5cfd2705c0e91e8dff754fbc51026cb32a8a511fda6e986053bbd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a837f6a4e8dc1b0cda26326ed191c520c4c0007b4aa65a225dac0ffe241621b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d188302de5fed681da52c266c876d425418c44435624dbd790b384f31b20f13e"
  end

  depends_on "scdoc" => :build
  depends_on "gumbo-parser"

  uses_from_macos "curl"
  uses_from_macos "expat"
  uses_from_macos "sqlite"

  def install
    # On macOS `_XOPEN_SOURCE` masks cfmakeraw() / SIGWINCH; override FEATURECFLAGS.
    featureflags = "-D_DEFAULT_SOURCE -D_BSD_SOURCE"
    featureflags << " -D_DARWIN_C_SOURCE" if OS.mac?

    system "make", "FEATURECFLAGS=#{featureflags}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    ENV["LANG"] = "en_US.UTF-8"
    ENV["LC_ALL"] = "en_US.UTF-8"

    assert_match version.to_s, shell_output("#{bin}/newsraft -v 2>&1")

    system "#{bin}/newsraft -l test 2>&1 || :"
    assert_match "[INFO] Okay... Here we go", File.read("test")
  end
end
