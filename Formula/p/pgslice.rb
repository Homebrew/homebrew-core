class Pgslice < Formula
  desc "Postgres partitioning as easy as pie"
  homepage "https://github.com/ankane/pgslice"
  url "https://github.com/ankane/pgslice/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "9c4b597c376217f81b40775906a07d1a294f22236f357bc88551b4a3a67b6172"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4b804ee8c22a1b234028f9119170e2172641c89fb39adf7c46ffcbb420aff89f"
    sha256 cellar: :any,                 arm64_sequoia: "39bfa33730c49b770aac11c0659096db74326789d732c4cb3290c3e3096008a0"
    sha256 cellar: :any,                 arm64_sonoma:  "817e87e1feb86c845b152b516b473731d58a456092631dcc0e2a98f5189ba201"
    sha256 cellar: :any,                 arm64_ventura: "bfa5d84ec12e40fc019bfb21f0e821d29943cfb37667bb811617924ad5b43adb"
    sha256 cellar: :any,                 sonoma:        "f5c84cf25d97b04edeeddd2c8617a69962bb0286b48c2cd8295c19bb70f42643"
    sha256 cellar: :any,                 ventura:       "1179a701dc2603dd555147458d93e0bb43c2fcfcbe3ffbbb7ad43035ff210fc7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d3ad8ecb6094fa3a807d1b24c0b022e41460860c789791d198487ddd58969f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ae944ff188b457801ef9cbd8aed418e6a41e43eada6051ea43180fb2e357fb9"
  end

  depends_on "postgresql@18" => :test
  depends_on "libpq"
  depends_on "ruby"

  resource "pg" do
    url "https://rubygems.org/gems/pg-1.6.0.gem"
    sha256 "26ea1694e4ed2e387a8292373acbb62ff9696d691d3a1b8b76cf56eb1d9bd40b"
  end

  resource "thor" do
    url "https://rubygems.org/gems/thor-1.4.0.gem"
    sha256 "8763e822ccb0f1d7bee88cde131b19a65606657b847cc7b7b4b82e772bcd8a3d"
  end

  def install
    ENV["GEM_HOME"] = libexec
    ENV["PG_CONFIG"] = Formula["libpq"].opt_bin/"pg_config"

    resources.each do |r|
      r.fetch
      system "gem", "install", r.cached_download, "--ignore-dependencies",
             "--no-document", "--install-dir", libexec
    end

    system "gem", "build", "pgslice.gemspec"
    system "gem", "install", "--ignore-dependencies", "pgslice-#{version}.gem"

    bin.install libexec/"bin/pgslice"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    ENV["LC_ALL"] = "C"

    postgresql = Formula["postgresql@18"]
    pg_ctl = postgresql.opt_bin/"pg_ctl"
    port = free_port

    system pg_ctl, "initdb", "-D", testpath/"test"
    (testpath/"test/postgresql.conf").write <<~EOS, mode: "a+"
      port = #{port}
    EOS
    system pg_ctl, "start", "-D", testpath/"test", "-l", testpath/"log"

    begin
      ENV["PGSLICE_URL"] = "postgres://localhost:#{port}/postgres"
      output = shell_output("#{bin}/pgslice prep users created_at day 2>&1", 1)
      assert_match "Table not found", output
    ensure
      system pg_ctl, "stop", "-D", testpath/"test"
    end
  end
end
