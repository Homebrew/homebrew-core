class Fakeroot < Formula
  desc "Provide a fake root environment"
  homepage "https://tracker.debian.org/pkg/fakeroot"
  url "https://deb.debian.org/debian/pool/main/f/fakeroot/fakeroot_1.38.1.orig.tar.gz"
  sha256 "37c5063942efe2e2aeefd6e71ae2690bcb9b7d512c53bc6409b54d0730cbdac1"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/f/fakeroot/"
    regex(/href=.*?fakeroot[._-]v?(\d+(?:\.\d+)+)[._-]orig\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3300c90039736122ee899f2dfb1bb57b12aa0d29fb5328e29f71b5e0951cb3fb"
    sha256 cellar: :any,                 arm64_sequoia: "439acd646fff5532553acc2b51e162f0690208eb68423911d772b8f30363d06e"
    sha256 cellar: :any,                 arm64_sonoma:  "ec1b39ba637fd10579c42f39c28c51d0709b22d82823c68b0150542c7711ee3e"
    sha256 cellar: :any,                 sonoma:        "eb58b257bb81209525a84f82a7968d680975c1eec008676ad4d1c1245545ba9a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c88511d07e9050d2382a48cdc0efb697fc1b364bfce99afd7648a688bc479580"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3b9b3e36b9b9ffdffc724d47cda22e5f419639b6bf236ecb12fb5cbf8c843eb"
  end

  on_linux do
    depends_on "libcap" => :build
  end

  def install
    args = ["--disable-silent-rules"]
    args << "--disable-static" if OS.mac?

    system "./configure", *args, *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fakeroot -v")
  end
end
