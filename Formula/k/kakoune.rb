class Kakoune < Formula
  desc "Selection-based modal text editor"
  homepage "https://github.com/mawww/kakoune"
  url "https://github.com/mawww/kakoune/releases/download/v2026.05.21/kakoune-2026.05.21.tar.bz2"
  sha256 "be1deb3fe9808a0733ab1057309da380bb757307e8fdbb22dc478b674b6bad34"
  license "Unlicense"
  head "https://github.com/mawww/kakoune.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af949c2fa7e4f6f6e0b31f51f70b4e72594e251f16dc4613e92242a0f93bd6da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0395267de4d2c982d25951d65219ba1327df38c19bcbd9c9575b71d84550ba8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "609dd30082a5dd8f0f22cf29a2077c9b23f6b18d60af2104f1e0e18b3c619fd3"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d9858048c95de9968cde5b364ce02131993c269b8fe2e7f20535dbba6acfd60"
    sha256 cellar: :any,                 arm64_linux:   "6ee1adf9a500941b4b72f4870dfd68880904fd7da4dcd3b95a3a319d3eb74e53"
    sha256 cellar: :any,                 x86_64_linux:  "e278d31043e2b11dde3115cf6f0a2263db88c7cc3ced7fea0a631f2eab863d7a"
  end

  on_catalina :or_older do
    depends_on "llvm" => :build
  end

  on_linux do
    depends_on "binutils" => :build
  end

  fails_with :clang do
    build 1200
    cause "Requires C++20"
  end

  # See <https://github.com/mawww/kakoune/blob/v2022.10.31/README.asciidoc#building>
  fails_with :gcc do
    version "10.2"
    cause "Requires GCC >= 10.3"
  end

  def install
    system "make", "install", "debug=no", "PREFIX=#{prefix}"
  end

  test do
    system bin/"kak", "-ui", "dummy", "-e", "q"

    assert_match version.to_s, shell_output("#{bin}/kak -version")
  end
end
