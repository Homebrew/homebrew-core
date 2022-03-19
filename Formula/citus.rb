class Citus < Formula
  desc "PostgreSQL-based distributed RDBMS"
  homepage "https://www.citusdata.com"
  url "https://github.com/citusdata/citus/archive/v10.2.5.tar.gz"
  sha256 "748beaf219163468f0b92bf5315798457f9859a6cd9069a7fd03208d8d231176"
  license "AGPL-3.0-only"
  head "https://github.com/citusdata/citus.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a473d61c192253889ece25d8805963fc0a06eed2a2f6ab2415a94d17c4036b01"
    sha256 cellar: :any,                 arm64_big_sur:  "8d9ff24d6d01e1a89056327cbc75aa13b983b4938894c568f784aaa612390b19"
    sha256 cellar: :any,                 monterey:       "e08b487cae176a7e2adf08a6c94a279aeaab5cf52908cc1fd6d23973fd3e5489"
    sha256 cellar: :any,                 big_sur:        "edabf4e6e3658330fa31a0bc13ee47a3bac5c87dd4713d0aaa49806ae66991d7"
    sha256 cellar: :any,                 catalina:       "93271095bc9abb5650f50da895b245978259483ef27194dab87022a9897d4211"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7102491ef3cc87fe4e9dacc5582b74a08a70ccecf2e24a9f1636266c6b79fd1"
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
