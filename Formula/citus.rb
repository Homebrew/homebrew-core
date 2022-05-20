class Citus < Formula
  desc "PostgreSQL-based distributed RDBMS"
  homepage "https://www.citusdata.com"
  url "https://github.com/citusdata/citus/archive/v10.2.5.tar.gz"
  sha256 "748beaf219163468f0b92bf5315798457f9859a6cd9069a7fd03208d8d231176"
  license "AGPL-3.0-only"
  head "https://github.com/citusdata/citus.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5c1284be900f79340a7deb11cab8ec6ae499ae4d5fb3a353c38af68294f605ee"
    sha256 cellar: :any,                 arm64_big_sur:  "8d8da700da3660cd9bc01aa509a25c7500e571d6353f0b718504d0307462692b"
    sha256 cellar: :any,                 monterey:       "aed158c5fc1a817655cf33f8fdf52a4b35735ad81740fd40100e93247c3acad4"
    sha256 cellar: :any,                 big_sur:        "c081472f3ea377cba1898543bbc45f9fbc750c8a53dd538645b16ccda66ba555"
    sha256 cellar: :any,                 catalina:       "8d206df19b0d0c30e866571deb14ad101f170e8e5cd6574de218a41a266e7b36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed813a71d6e8c6e3c78627707f6bfbf1dd135959f1518748318b956666f62400"
  end

  depends_on "lz4"
  depends_on "postgresql"
  depends_on "readline"
  depends_on "zstd"

  uses_from_macos "curl"

  def install
    ENV["PG_CONFIG"] = Formula["postgresql"].opt_bin/"pg_config"

    system "./configure"

    # workaround for https://github.com/Homebrew/legacy-homebrew/issues/49948
    system "make", "libpq=-L#{Formula["postgresql"].opt_lib} -lpq"

    # Use stage directory to prevent installing to pg_config-defined dirs,
    # which would not be within this package's Cellar.
    mkdir "stage"
    system "make", "install", "DESTDIR=#{buildpath}/stage"

    path = File.join("stage", HOMEBREW_PREFIX)
    lib.install (buildpath/path/"lib").children
    include.install (buildpath/path/"include").children
    (share/"postgresql/extension").install (buildpath/path/"share/postgresql/extension").children
  end
end
