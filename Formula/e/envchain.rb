class Envchain < Formula
  desc "Secure your credentials in environment variables"
  homepage "https://github.com/sorah/envchain"
  url "https://github.com/sorah/envchain/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "832bcf58037db6187f7327282e347e45627ea617c2e09a9e6d18629e7310fff9"
  license "MIT"
  head "https://github.com/sorah/envchain.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "1c6122f97e7ba7946f270192b4a995011ebc61f8f03948ccd06ed7e0e7df95c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "89bc49ffc1341fb5f06e5510be523ddb5d3a7270ad02a53382505f2cb817675b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "08f5b3cde3d1896f4fca18a13095967ea1d127173e5ee23e780fcc12fd6baf9f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "24af1fb8d859658e4cfbc05b3e9fa27dda8e2279c0ea837c690bdd12923687b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8cc5dc5ec2f1fac17348730ba22508f9ee2bce670312987c2637257f7e852412"
    sha256 cellar: :any_skip_relocation, sonoma:         "b9ac4877ddba27b20d986e8ade239c4fc12e9b85968d2f07106cbd3f1504a8ec"
    sha256 cellar: :any_skip_relocation, ventura:        "a3f83b8b0b6ea0236e3474a1e1a2a7d5c931be0bcd95d8f29f5d3b15ffd4e387"
    sha256 cellar: :any_skip_relocation, monterey:       "1e9696dfc24f702c88cdb3f02fa4d462524d8b3e95cf4eaafd8c315122da9179"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "46dccfdddf8a917b6475930bd658b64103b7577f4fe5adff5f6c15dbb6aca052"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a8253f12f7d1ec624b755a99a0906b501b6dfb4d299ddb552c8a35a397293cc"
  end

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "glib"
    depends_on "libsecret"
    depends_on "readline"
  end

  def install
    system "make", "DESTDIR=#{prefix}", "install"
  end

  test do
    assert_match "envchain version #{version}", shell_output("#{bin}/envchain 2>&1", 2)
  end
end
