class Globe < Formula
  desc "Prints ASCII graphic of currently-lit side of the Earth"
  homepage "https://web.archive.org/web/20230605040209/https://www.acme.com/software/globe/"
  url "https://web.archive.org/web/20230605040209/https://www.acme.com/software/globe/globe_14Aug2014.tar.gz"
  version "0.0.20140814"
  sha256 "5507a4caaf3e3318fd895ab1f8edfa5887c9f64547cad70cff3249350caa6c86"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9a2871805874a01d7197dcfec9a4bee19ec0b66717f8c06329ebf1777b684019"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4473c2c0beaa4ed43eb61e261c0dea124561f7060500b34f6dbe0d8ed2a74f54"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7aaea040d2d0551c2b5ff578222fceb20b0768d9a040c1ab7091f919b7df1235"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d614010f862d04bbc2fc08ba4f220fde562ee07f08fe7f2fe15470afa2ad09c1"
    sha256 cellar: :any_skip_relocation, sonoma:         "a03d014e1e501160937532cb1019fe10b446530ba6771586917cfafa3726ed17"
    sha256 cellar: :any_skip_relocation, ventura:        "f9fa4bb89e99be5518c6847948deac3e5b3406b1ea9b78e27ebc0936df60a654"
    sha256 cellar: :any_skip_relocation, monterey:       "af722a0052f1e690155ebe6a1aa9640ac733ebcb76c0cd37335d21942e1f160c"
    sha256 cellar: :any_skip_relocation, big_sur:        "d0c0291f6767d96e3e5e21dfbdd71f793e83208841de96b1d2907c509b5dc62d"
    sha256 cellar: :any_skip_relocation, catalina:       "813ec2be614ca68c63af2b1830b6aa5129c5b65ce3c0d3aa6fa6d8f826f674e5"
    sha256 cellar: :any_skip_relocation, mojave:         "a5a07b3dfade00debcfe123b8ce103ec33649c9152f89676fce5b70c0f0fec8a"
    sha256 cellar: :any_skip_relocation, high_sierra:    "f61e4026debce10b4611ce963f5387721296b9bd84120eecfcff275facf76f32"
    sha256 cellar: :any_skip_relocation, sierra:         "20488fcd0137e0d2a05ea3bfa91adc2f45460f05bb01f26e41005ccafc3e8c54"
    sha256 cellar: :any_skip_relocation, el_capitan:     "11acded7be5d1ba22260d039e3daf4fdc4cac49ebcd234c879da655a1532c22f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45f34a09b90224f8c3026702be8b9eb682417c8efca350ae807faa2484b603da"
  end

  # Upstream uses weak ciphers which modern OpenSSL rejects,
  # so fetching and livechecking no longer work.
  # Last release on 2014-08-13
  deprecate! date: "2023-12-06", because: :unmaintained

  def install
    bin.mkpath
    man1.mkpath

    system "make", "all", "install", "BINDIR=#{bin}", "MANDIR=#{man1}"
  end

  test do
    system "#{bin}/globe"
  end
end
