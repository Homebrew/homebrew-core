class Postgrest < Formula
  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https://github.com/PostgREST/postgrest"
  url "https://github.com/PostgREST/postgrest/archive/refs/tags/v13.0.1.tar.gz"
  sha256 "3145708f8f13b934fbd2fd29eefef7a497757184cdd34f238ddda6d826ceaa6a"
  license "MIT"
  head "https://github.com/PostgREST/postgrest.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9a1b1bd028c0538ec197c689222bd7b962d2e435e866ec37d33008214c4f4ae2"
    sha256 cellar: :any,                 arm64_sonoma:  "4267906f3d6a171f12d1b6d8a448870a6978ac714c07fd74b50c0a2799f52a27"
    sha256 cellar: :any,                 arm64_ventura: "144cabbca4b20fca42dde259bb1648b3f09b8eff4fef94f5ce7d29441a6670e5"
    sha256 cellar: :any,                 sonoma:        "47cea3500d290daa4e7ab408f965fa25738daf9f53eaf20d46a30974715f9e46"
    sha256 cellar: :any,                 ventura:       "8e3d3157d8d355ddbebd4dbaff1870e8887f51333daed0111f8950445dab7370"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56e0fd2e6d19b016ca3bb50a1844898bcbd3b8ff9885d04edc21716dbbd3d0e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "310d3a525890605b1829224e8fcb3a20ce1be046ec9ec513dcbd6f766a84f7f8"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.8" => :build # GHC 9.10 blocked by deps, e.g. https://github.com/protolude/protolude/issues/149
  depends_on "libpq"

  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", "--ignore-project", *std_cabal_v2_args
  end

  test do
    output = shell_output("#{bin}/postgrest --dump-config 2>&1")
    assert_match "db-anon-role", output
    assert_match "Failed to query database settings for the config parameters", output

    assert_match version.to_s, shell_output("#{bin}/postgrest --version")
  end
end
