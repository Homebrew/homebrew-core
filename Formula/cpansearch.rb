class Cpansearch < Formula
  desc "CPAN module search written in C"
  homepage "https://github.com/c9s/cpansearch"
  url "https://github.com/c9s/cpansearch/archive/0.2.tar.gz"
  sha256 "09e631f361766fcacd608a0f5b3effe7b66b3a9e0970a458d418d58b8f3f2a74"
  revision 1
  head "https://github.com/c9s/cpansearch.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "1aa72a4b6e9ec453f1fa20b57bf095f7e0446ec066d7718e115c67d87e95fa64"
    sha256 cellar: :any, arm64_big_sur:  "37c73b9a5acde5677d8cb3d423c671eba4f0fae0e01fd057789c20184b033a54"
    sha256 cellar: :any, monterey:       "b81cf3ff44e7fbd6abe403ce13262cb94a6ce7dd126e881e81a0793d673527f3"
    sha256 cellar: :any, big_sur:        "5cf4f854e56de6fb4d1b992f8c3ba9004dac26aa676007841042e8a30e0539c3"
    sha256 cellar: :any, catalina:       "f5ad7240f2e1d3004c9b80d232192bbc50dcf777bdfe92fa73172e93476f5ef2"
    sha256 cellar: :any, mojave:         "5d583c37a54d9d6f96c625faf75b40c53a2ae59b8c9960f51a6f9bc215fa5bae"
    sha256 cellar: :any, high_sierra:    "e8197124d1341e8e5d8348cd322eac2bfa782d885c808b5322a340eb7b91ba8b"
    sha256 cellar: :any, sierra:         "6b4545b0455642a3b4f3c92ef480e704742cd06fd6ff64d24f9a5edbb3bc33a7"
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "ncurses" if DevelopmentTools.clang_build_version >= 1000

  def install
    system "make"
    bin.install "cpans"
  end

  test do
    output = shell_output("#{bin}/cpans --fetch https://cpan.metacpan.org/")
    assert_match "packages recorded", output
  end
end
