class Newsraft < Formula
  desc "Terminal feed reader"
  homepage "https://codeberg.org/newsraft/newsraft"
  url "https://codeberg.org/newsraft/newsraft/archive/newsraft-0.36.tar.gz"
  sha256 "769dce748a4de741f1888eb199f71aeb41068b8527e0d5779fe0eb51fbbd72e3"
  license "ISC"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "24efac7ccd97cd933810f8351e6836d17d62b6f8da3224b2c15123ab928cd20c"
    sha256 cellar: :any,                 arm64_sequoia: "4c9892f68c9f211793b07c82bbba19773d0cf38fb67516eb468fbce07feb60af"
    sha256 cellar: :any,                 arm64_sonoma:  "f84d2d26f3c357119e1499f6cd1117f80a87934d95d28d1964a02b70e26cae8b"
    sha256 cellar: :any,                 sonoma:        "c44c9bcca97ce225425e5eb305865a2891ac3c73e1c15caec379e7a08ee4d4a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e7d1da13d537996da6ea194a16d39eb06c78a71b5058baf0f18c67e3b96b472"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83120bebc5dc9fa38f9f05619f63a3066f3d5f2a8bd1fef70cf0cd1dac4a8590"
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
