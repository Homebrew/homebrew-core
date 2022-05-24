class Mlogger < Formula
  desc "Log to syslog from the command-line"
  homepage "https://github.com/nbrownus/mlogger"
  url "https://github.com/nbrownus/mlogger/archive/v1.2.0.tar.gz"
  sha256 "141bb9af13a8f0e865c8509ac810c10be4e21f14db5256ef5c7a6731b490bf32"
  license "BSD-4-Clause-UC"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2446f830d72176c5dda94e2023f588fea40cb7f0d1fbcce88e07f7ba56cb414"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ae9dd6052251a2283883741ec0c1643cf70e62c2acbda9bec06971375b98eced"
    sha256 cellar: :any_skip_relocation, monterey:       "234b0797fe08d79cd45ee6e2587fafe3322657b70b386e3327f4dc7a103edb3f"
    sha256 cellar: :any_skip_relocation, big_sur:        "251a03f6e4954f46183a2eaa1ead28e993974d1ab5e6b4b6ae85d1777b15a379"
    sha256 cellar: :any_skip_relocation, catalina:       "553fe787f0d6a1982544a74ec268d3db6bdf800d538238cd627ba39d8bb1cc37"
    sha256 cellar: :any_skip_relocation, mojave:         "003cc065352384eeb31109f19c9be3223b5e94cbe859dc3c55c9b1f4e3bd0cb3"
    sha256 cellar: :any_skip_relocation, high_sierra:    "9eec751c684f9043f667bf5e9d793379ca3a9824a05b359ed91af2d7e41d52b7"
    sha256 cellar: :any_skip_relocation, sierra:         "1f7392a3d16a2bf595487a4b35bf5c866fa00c0967629eef46f07cbf6e696ff4"
    sha256 cellar: :any_skip_relocation, el_capitan:     "e1f78a9ef569085efcac8c41bd2a70feda85e7fcba5eb7b46a9ee5341cf8cb2d"
    sha256 cellar: :any_skip_relocation, yosemite:       "f64331a815b26047bc982340650aae806a568a10060adfc819e25d077059af2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "893dd3f909fe05978eef82de9222ba24cb05e208d73d63f5ef591098df8ceb56"
  end

  def install
    system "make"
    bin.install "mlogger"
  end

  test do
    system "#{bin}/mlogger", "-i", "-d", "test"
  end
end
