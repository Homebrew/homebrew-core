class Hypopg < Formula
  desc "Hypothetical Indexes for PostgreSQL"
  homepage "https://github.com/HypoPG/hypopg"
  url "https://github.com/HypoPG/hypopg/archive/refs/tags/1.4.5.tar.gz"
  sha256 "9d1981af0c55ac75ab4e2648e0050ee626c1af4c68b24259e3c744ff5211ce49"
  license "PostgreSQL"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bc7096a0f2486cc661a57eb1a7b1806a97697c2b9a947c8c895c6a470222fe69"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f7fb5f4b7b7c2e6ef1e7773a3d407ada87adec7ef5373fcc7438f72b892029d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9d7cceb7175ad6ba870027ad5ea8b4a38f027f235a330f275ef634887051a265"
    sha256 cellar: :any,                 arm64_linux:       "80950ebd8821836fb04046e4c96255c01232358e0cba5ea2f117f3a5b34fb655"
    sha256 cellar: :any,                 x86_64_linux:      "751bb0ff6799880642a0109bf2ad31324e4c795ec954e5c5e267e542365e6fe4"
  end

  depends_on "postgresql@17" => [:build, :test]
  depends_on "postgresql@18" => [:build, :test]

  def postgresqls
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("postgresql@") }
  end

  def install
    odie "Too many postgresql dependencies!" if postgresqls.count > 2

    postgresqls.each do |postgresql|
      ENV["PG_CONFIG"] = postgresql.opt_bin/"pg_config"
      system "make"
      system "make", "install", "pkglibdir=#{lib/postgresql.name}",
                                "datadir=#{share/postgresql.name}",
                                "pkgincludedir=#{include/postgresql.name}"
      system "make", "clean"
    end
  end

  test do
    ENV["LC_ALL"] = "C"
    postgresqls.each do |postgresql|
      pg_ctl = postgresql.opt_bin/"pg_ctl"
      psql = postgresql.opt_bin/"psql"
      port = free_port

      datadir = testpath/postgresql.name
      system pg_ctl, "initdb", "-D", datadir
      (datadir/"postgresql.conf").write <<~EOS, mode: "a+"
        port = #{port}
        unix_socket_directories = '#{testpath}'
      EOS
      system pg_ctl, "start", "-D", datadir, "-l", testpath/"log-#{postgresql.name}"
      begin
        system psql, "-h", testpath, "-p", port.to_s, "-c", "CREATE EXTENSION hypopg;", "postgres"
      ensure
        system pg_ctl, "stop", "-D", datadir
      end
    end
  end
end
