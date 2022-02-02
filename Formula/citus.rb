class Citus < Formula
  desc "PostgreSQL-based distributed RDBMS"
  homepage "https://www.citusdata.com"
  url "https://github.com/citusdata/citus/archive/v10.2.4.tar.gz"
  sha256 "bfe62893ad8b571737b38e9b6bca35650fdf8f89ce9da3996d6634090c97db7e"
  license "AGPL-3.0-only"
  head "https://github.com/citusdata/citus.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "5f6430e06badacfd9c70e898ac854b5926af1c56231ac2999de5629c6caad611"
    sha256 cellar: :any, arm64_big_sur:  "e5fa12d8b0b3c07ce08f1cbbf8d6b1d986b8e82f86e19210d17a4323dfc2f2fe"
    sha256 cellar: :any, monterey:       "e54159991712803e281906b82e2c180e5113820b17eb6a5cd6f8bb87ba98922a"
    sha256 cellar: :any, big_sur:        "ddf037c6fc8ad951ba360aa9e8f105967d293a498f6c76361ef4ba1938a50fac"
    sha256 cellar: :any, catalina:       "e152e154ba4a75aaba4465b17470b1737a2d604b040f383089c6baf18ea6de4f"
  end

  depends_on "lz4"
  depends_on "postgresql"
  depends_on "readline"
  depends_on "zstd"

  def install
    ENV["PG_CONFIG"] = Formula["postgresql"].opt_bin/"pg_config"

    system "./configure"

    # workaround for https://github.com/Homebrew/homebrew/issues/49948
    system "make", "libpq=-L#{Formula["postgresql"].opt_lib} -lpq"

    # Use stage directory to prevent installing to pg_config-defined dirs,
    # which would not be within this package's Cellar.
    mkdir "stage"
    system "make", "install", "DESTDIR=#{buildpath}/stage"

    bin.install Dir["stage/**/bin/*"]
    lib.install Dir["stage/**/lib/*"]
    include.install Dir["stage/**/include/*"]
    (share/"postgresql/extension").install Dir["stage/**/share/postgresql/extension/*"]
  end
end
