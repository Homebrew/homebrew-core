class Kakoune < Formula
  desc "Selection-based modal text editor"
  homepage "https://github.com/mawww/kakoune"
  url "https://github.com/mawww/kakoune/releases/download/v2024.05.18/kakoune-2024.05.18.tar.bz2"
  sha256 "dae8ac2e61d21d9bcd10145aa70b421234309a7b0bc57fad91bc34dbae0cb9fa"
  license "Unlicense"
  head "https://github.com/mawww/kakoune.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "574e7864ad00cf1450df98b4e6e442d6809018fc3f2f03e517cbb90f512bbb81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "42850e284b85aad3865b80947c8a2b74644148ec3b05f8e1470f5438453a4f4b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f261b85b550552526b4d3fef66f1da40c4e4d84089196b6d066b3c2a271fbd21"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a9bde4e123c7b07770794f92dc225da5da862d42c739cbae0d2498d3280a0d7"
    sha256 cellar: :any_skip_relocation, sonoma:         "301f7dba32850275799750dedaef50a525d004cca2d6439d9aa609a4d00689e1"
    sha256 cellar: :any_skip_relocation, ventura:        "f4a32d5ed1213ddc0ed831e9974c154023fc623d0fddc2af4aae718115f79482"
    sha256 cellar: :any_skip_relocation, monterey:       "331edc367fa3a3905e1456d9dea0b3699bc0358281a7ae88f7adf1466ee90c11"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "44986966430f14e95529bc4403f326e39f14863bbdb3f20bd30cb8b43d134874"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bdf7a8135634ef2b09dd76b622d9d852b51c156c09b6e1e0fa11b801cf376310"
  end

  uses_from_macos "llvm" => :build, since: :big_sur

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
