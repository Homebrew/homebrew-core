class Clib < Formula
  desc "Package manager for C programming"
  homepage "https://github.com/clibs/clib"
  url "https://github.com/clibs/clib/archive/2.8.3.tar.gz"
  sha256 "0ad8262d13ef138a12452e67e081e3eb31a264e2040cfce09417e8f7eed4e1f5"
  license "MIT"
  head "https://github.com/clibs/clib.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "62afdbcd5bb7648517ce1aba70e8d2c33e3c47fd657cda7f5fe4f0f1d5766a48"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e32fd4fabf6ae444d06ac04f3f469fc8b45a6313db7d5d33da2c41974e5d991"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "531b420f544115b76de3f062ca797e29d8d67033606d900fb4f24110be6d79a4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5570b36fd28e42add8fc2bacc2bde04bbba0964c703b54a166cb28edade444da"
    sha256 cellar: :any_skip_relocation, sonoma:         "1555405363781981ca9907281190f8b0f160714741816318c31a3d53bd2373bb"
    sha256 cellar: :any_skip_relocation, ventura:        "191e02d060b9a2802b7bc9e99dd3a68572ee3cc68f732f5de4208a32c7961586"
    sha256 cellar: :any_skip_relocation, monterey:       "690ee73163b6fa61ad18f2edf33191f073e547ffa1b996573daf1d563e235043"
    sha256 cellar: :any_skip_relocation, big_sur:        "42094b31e28fa21086e7765abb6d09e02eff56bea9088227895dee48e97c1477"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9fae1b2b9a3c8dd01a954573192eb2106fd0b2590c83180210c11cbdbe38be8"
  end

  uses_from_macos "curl"

  def install
    ENV["PREFIX"] = prefix
    system "make", "install"
  end

  test do
    system "#{bin}/clib", "install", "stephenmathieson/rot13.c"
  end
end
