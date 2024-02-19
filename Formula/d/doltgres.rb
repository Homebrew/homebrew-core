class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https://github.com/dolthub/doltgresql"
  url "https://github.com/dolthub/doltgresql/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "2a476034582e04bcccbdfa20ebb3de7817e5798db686053e760c21a7dda992c8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c522e5451f3f55c7995c0fe11933d83043db7ee09747a06ecb25a6d3e8f4ba17"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d8cc2469865215653386f60a5ac00bb40cb05958534ff8b083fef9f5b18070b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88a4989fd696fb24fe28e2b8fbfc490792570febf48dc899de63c852f292051e"
    sha256 cellar: :any_skip_relocation, sonoma:         "a76afe781ff26772189010597235e9ceb8130777f05751a589818e445cc3b22e"
    sha256 cellar: :any_skip_relocation, ventura:        "ba4893cd6cb0d1de127fff0991fa173d976b18aa40506fef00e3b97d6cd3cd07"
    sha256 cellar: :any_skip_relocation, monterey:       "ae2c6cdfff288bfdbc3820130b1b42272c421265403c8e402ef85a42e7891128"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8382b0e974c7e5002029d616c5c0d159a36f75331c2d2578b6a1cc88855cadab"
  end

  depends_on "go" => :build
  depends_on "libpq" => :test

  def install
    system "./postgres/parser/build.sh"
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    fork do
      exec bin/"doltgres"
    end
    sleep 5
    psql = "#{Formula["libpq"].opt_bin}/psql -h 127.0.0.1 -U doltgres -c 'SELECT DATABASE()'"
    assert_match "doltgres", shell_output(psql)
  end
end
