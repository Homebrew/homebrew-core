class Kakoune < Formula
  desc "Selection-based modal text editor"
  homepage "https://github.com/mawww/kakoune"
  url "https://github.com/mawww/kakoune/releases/download/v2023.08.05/kakoune-2023.08.05.tar.bz2"
  sha256 "3e45151e0addd3500de2d6a29b5aacf2267c42bb256d44a782e73defb29cda5c"
  license "Unlicense"
  head "https://github.com/mawww/kakoune.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cfd67ffe60266d340d800d7d6d4bf5b4177b174d292eb2943ce533786a66070d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0968b727f6e4afd1d06ad78d26ac18b30efc4cbd36fdce9ff26e7b6f87c7c498"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dbae4b9dc5c4061e5bd6b818b41f7cdbca7a3e5468e5f3fbf693635563d731a2"
    sha256 cellar: :any_skip_relocation, ventura:        "d41c7940b79b65a545d746525745a623e748cfa5d49b0ca00841e4fed1502cbe"
    sha256 cellar: :any_skip_relocation, monterey:       "89923a6e5ff0cecbcebb1591486b5fe9eda7477d6671124385c273b2fe439fae"
    sha256 cellar: :any_skip_relocation, big_sur:        "3b9ce6adf312565c15b8515df391037d44c47a17bfa241960a9a91d2e5e48ce1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a08816f7386a35390528c43d206bae3c6579fd3e202a65e63170545ba71ab8a0"
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
    cd "src" do
      system "make", "install", "debug=no", "PREFIX=#{prefix}"
    end
  end

  test do
    system bin/"kak", "-ui", "dummy", "-e", "q"
  end
end
