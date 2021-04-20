class Proper < Formula
  desc "QuickCheck-inspired property-based testing tool for Erlang"
  homepage "https://proper-testing.github.io"
  url "https://github.com/proper-testing/proper/archive/v1.3.tar.gz"
  sha256 "7e59eeaef12c07b1e42b0891238052cd05cbead58096efdffa3413b602cd8939"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6a1d458a2c8a8de933313461c08be393fa6d7fc52dbe97c1408f072af006759a"
    sha256 cellar: :any_skip_relocation, big_sur:       "f2e6928824479ca03e6998758891da6812e1afa7dfa51387fa7857604d3b10b4"
    sha256 cellar: :any_skip_relocation, catalina:      "34011621b0cd440a49ee2c13d0bd968b7cf8ed8b0b817fbd6793082de5d4728c"
    sha256 cellar: :any_skip_relocation, mojave:        "a93bfdd9a7558b9ad0cc013f3aca0cadfe86535948730ab6861c10931cae4b92"
    sha256 cellar: :any_skip_relocation, high_sierra:   "f9f6404b3c025d06fb1b6ab0155716fe5f59f337ac6884b92d4ac01d6677b4c7"
    sha256 cellar: :any_skip_relocation, sierra:        "a80e754b0bb2ce17d223034734cd1aa473532ba743cf45cbff89fa154af18220"
  end

  depends_on "erlang"

  def install
    system "make"
    prefix.install Dir["ebin", "include"]
  end

  test do
    output = shell_output("erl -noshell -pa #{opt_prefix}/ebin -eval 'io:write(code:which(proper))' -s init stop")
    refute_equal "non_existing", output
  end
end
