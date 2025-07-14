class Pgslice < Formula
  desc "Postgres partitioning as easy as pie"
  homepage "https://github.com/ankane/pgslice"
  url "https://github.com/ankane/pgslice/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "9a43932c4e75f83cc7d984ee7d17447bba53dec48f844e9228fbf65f1b9be4dc"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d41bc238c39617a3b928967797356b30e2324ac2e362840d2c37c7c7533102e4"
    sha256 cellar: :any,                 arm64_sonoma:  "4714494f6970bc7cefc529b3eb5bef13d9629a72e53d210c57dddf874f2e1cdd"
    sha256 cellar: :any,                 arm64_ventura: "9bfb63ca6237c991d5574fd9a09b7fb3740463404842c964a6a4344c27a662e4"
    sha256 cellar: :any,                 sonoma:        "5b685150986b534cc9bb106f9245c41acc3c6986a921f7fc82be9b9712cbdddf"
    sha256 cellar: :any,                 ventura:       "534bc973ce2bda628733c8e11316c855cd5041f68ebff74130631650a0144761"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "beabbe412cd4ec6c471b408aed0c2834ae2eaa7d2804226ca4ca44aa1c063774"
  end

  depends_on "postgresql@17" => :test
  depends_on "libpq"
  depends_on "ruby"

  resource "pg" do
    url "https://rubygems.org/gems/pg-1.5.9.gem"
    sha256 "761efbdf73b66516f0c26fcbe6515dc7500c3f0aa1a1b853feae245433c64fdc"
  end

  resource "thor" do
    url "https://rubygems.org/gems/thor-1.3.2.gem"
    sha256 "eef0293b9e24158ccad7ab383ae83534b7ad4ed99c09f96f1a6b036550abbeda"
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

    postgresql = Formula["postgresql@17"]
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
