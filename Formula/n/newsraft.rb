class Newsraft < Formula
  desc "Terminal feed reader"
  homepage "https://codeberg.org/newsraft/newsraft"
  url "https://codeberg.org/newsraft/newsraft/archive/newsraft-0.38.tar.gz"
  sha256 "60da202448e104687c429a6d7b227ec7d038f7b906001dda594c78847efcc378"
  license "ISC"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "771e56d73f43ab07b8fcb90cfa36eb1653711085b0e68ef45dd316dbf72da1b5"
    sha256 cellar: :any, arm64_tahoe:       "447bd4cd76b0489da0f0f59e82b56b8edaac09bbf4ca9a833296ef78da8b734f"
    sha256 cellar: :any, arm64_sequoia:     "e458f48acd960f29a3c215fe11a685519f4de5b0cd12f19c6c4cd50c3358a355"
    sha256 cellar: :any, arm64_linux:       "26c054c51276d9634a304bfc0d22f21f3192f9c647d6e5ccf6d2fc28ec36ad30"
    sha256 cellar: :any, x86_64_linux:      "5352ed608aaac177ef060b26b45ab06bca89a3eda3a7395c7de357bd7550a06d"
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
