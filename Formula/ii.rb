class Ii < Formula
  desc "Minimalist IRC client"
  homepage "https://tools.suckless.org/ii/"
  url "https://dl.suckless.org/tools/ii-1.9.tar.gz"
  sha256 "850cb323b583d261b51bda9993ee733334352a8e6ca1e2f02b57c154bf568c17"
  license "MIT"
  head "https://git.suckless.org/ii", using: :git, branch: "master"

  livecheck do
    url "https://dl.suckless.org/tools/"
    regex(/href=.*?ii[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9452385f64727d3e54a45e3e7e24a41bb4014df20ffd6d1ec7cd75de14749d0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a5de14cd12cba7a7ff58f2c5db87c300a3dcf69268dbbfbca552dbaf575568c0"
    sha256 cellar: :any_skip_relocation, monterey:       "760f3e4bd676ff26340b2796568d5e5b3727feb5da2094996ecb7ea0c1ecc4cc"
    sha256 cellar: :any_skip_relocation, big_sur:        "a58cf380ab73f600dadce4712328013a3ea3b0b65009fda1a3d2dc5e92741716"
    sha256 cellar: :any_skip_relocation, catalina:       "deb41b4c38d4b8e6cd2f3e9d8acea872a8daa694486ee59edd684248a7e74f4b"
    sha256 cellar: :any_skip_relocation, mojave:         "c8e535b535af9adf8c3c3e760849f581d3e93ec227ae9f0ae2f30490b44e9c4d"
    sha256 cellar: :any_skip_relocation, high_sierra:    "dcc9e7c86395491f5a62dd87dfcfb0f1b8b89a8f5ceb4e767ac70cf60ef350cd"
    sha256 cellar: :any_skip_relocation, sierra:         "a83511296e08d8ec1d126bb09574b02856f382f3f504b6f2b256cab6bd645ed1"
    sha256 cellar: :any_skip_relocation, el_capitan:     "eeba4fb4ec437895a9946bbbb00186ff05277ce9d57e8bbe29e1db5596d8a70f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65635369b704678c7b8e9e116df8421b2599b4fda0aa728cffc86d5c10438320"
  end

  def install
    # macOS already provides strlcpy
    if OS.mac?
      inreplace "config.mk" do |s|
        s.gsub! "= -DNEED_STRLCPY -Os", "= -Os"
        s.gsub! "= strlcpy.o", "="
      end
    end

    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    port = free_port
    output = shell_output("#{bin}/ii -s localhost -p #{port} 2>&1", 1)
    assert_match "#{bin}/ii: could not connect to localhost:#{port}:", output.chomp
  end
end
