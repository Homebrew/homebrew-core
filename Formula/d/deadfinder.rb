class Deadfinder < Formula
  desc "Finds broken links"
  homepage "https://github.com/hahwul/deadfinder"
  url "https://github.com/hahwul/deadfinder/archive/refs/tags/2.0.2.tar.gz"
  sha256 "13d3d4b0392d6b1548071d44dc03a14e790ea161781d5a57a196577316a97543"
  license "MIT"
  head "https://github.com/hahwul/deadfinder.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3cd70822a8e851cba61fc82b404a3c288027c5e1428085419572da755190f3e7"
    sha256 cellar: :any,                 arm64_sequoia: "da399f4212adcd55edf32b957d467ba0ca4074b5b152b98761019110867b2807"
    sha256 cellar: :any,                 arm64_sonoma:  "56b8210526219201d86964a11f215964e61bb78b21ad8663931f052c670f2d96"
    sha256 cellar: :any,                 sonoma:        "25aae4c594c1a3a66a7f3c89df5958f044e61b09eb66989b135eb3607178314a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c0b06102fec2f436837c35f2990b04ad9bb64dea9ba7e51a3bb6cbdb835b5ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b3b0164aa904fda4b1cb754c6cd4cb450fd7ff3d0004f0f6ad5134f845c2666"
  end

  depends_on "cmake" => :build
  depends_on "crystal" => :build
  depends_on "pkgconf" => :build
  depends_on "bdw-gc"
  depends_on "libevent"
  depends_on "libyaml"
  depends_on "openssl@3"
  depends_on "pcre2"

  uses_from_macos "libxml2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "shards", "build", "--production", "--release", "--no-debug"
    bin.install "bin/deadfinder"

    generate_completions_from_executable(bin/"deadfinder", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/deadfinder version")

    assert_match "Task completed", shell_output("#{bin}/deadfinder url https://brew.sh")
  end
end
