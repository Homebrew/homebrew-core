class Citus < Formula
  desc "PostgreSQL-based distributed RDBMS"
  homepage "https://www.citusdata.com"
  url "https://github.com/citusdata/citus/archive/v11.0.5.tar.gz"
  sha256 "6f1e57de9beac4c08329e74b58d8c77ebde67f418a90e5b15f4472f1ad3f0688"
  license "AGPL-3.0-only"
  head "https://github.com/citusdata/citus.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "647e93c2156750c695bdcf51a637f36f385c275e788d387ef7129a5e13499b04"
    sha256 cellar: :any,                 arm64_big_sur:  "239c863c690b48bf5da802c8967de0840620174a79cd70c9f361704fb1a65d11"
    sha256 cellar: :any,                 monterey:       "42248b9e583cbb1cb72420f428def284024c230ab031ce15884e97ca1c7a4e69"
    sha256 cellar: :any,                 big_sur:        "d05534970019991ec81210a74e4d14310ed6313eb2e6ce0825e738852f9311b7"
    sha256 cellar: :any,                 catalina:       "32b0d8f6c076d5264255e6c61c389da9b0ffde18377e01f87e13a88f428fdb7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed3e09f7ea4656b77e04a55f391a818390e2059e55fbe8997f8b169f35017c76"
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
