class Newsraft < Formula
  desc "Terminal feed reader"
  homepage "https://codeberg.org/newsraft/newsraft"
  url "https://codeberg.org/newsraft/newsraft/archive/newsraft-0.36.tar.gz"
  sha256 "d6aeebd3f1b2c897c8c9b29e1f5ed91751969681d1deafc31a9d85d139793ad5"
  license "ISC"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "58a755e823da6a7f93ad16ea5e57d6ea5409a2548e1da66c8d681f7b22537183"
    sha256 cellar: :any, arm64_sequoia: "9b512acf067898c5864600889998e150dc5111d2228acd6ee89d180585c0175d"
    sha256 cellar: :any, arm64_sonoma:  "a6ffc299e0ca8554078beb797cd657bdb29b9f365d113957f2cebd398020d8b8"
    sha256 cellar: :any, sonoma:        "13f56ad55bf3bda421bef3b7d4596a1847bec9fa4cbd78bf8a7f39bfecc87569"
    sha256 cellar: :any, arm64_linux:   "3e395f28b258d4e5cf4b69f6a9b1defbab43656ee46d62cdd5291f171de465c5"
    sha256 cellar: :any, x86_64_linux:  "cd8fbdbbe65992b92e535430db560994aecaedf3268c7620b6881d56a9f9ea23"
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
