class Miasma < Formula
  desc "Trap AI web scrapers in an endless poison pit"
  homepage "https://github.com/austin-weeks/miasma"
  url "https://github.com/austin-weeks/miasma/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "f5d6dfb6e035acd5822e083d3ab01a004b408c9a5597456893417cd377548d92"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f0174c6e7f0b4cd6d4149e8aa94a6af7535e46af26994ed2e7a1cc45883082ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7ce39755a5df1acb37f054057d3d4dbc0200737827743318d1be1f31e845af1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "398f0d677a3c7bd055cb7f5592a3c33afd07a47e4bd41ee5057ca179de15a256"
    sha256 cellar: :any_skip_relocation, sonoma:        "8e7152acb223d6fa6709859b9e3a55e35433f9bc72073d6baa81e67c594c3038"
    sha256 cellar: :any,                 arm64_linux:   "2812562fcc6b20c65115221be9d5940c1e3908bb02ab2c9dd5a503be63b8182a"
    sha256 cellar: :any,                 x86_64_linux:  "84bbd60da4749f07badcf4192723bebd2f507689a9ab9bc1015cd1da8dc94cff"
  end

  depends_on "rust" => :build

  uses_from_macos "sqlite"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    port = free_port
    pid = spawn bin/"miasma", "--host", "127.0.0.1", "--port", port.to_s

    # give the server a second to start up
    sleep 3
    system "curl", "-sSf", "http://127.0.0.1:#{port}/"
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
