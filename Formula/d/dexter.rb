class Dexter < Formula
  desc "Automatic indexer for Postgres"
  homepage "https://github.com/ankane/dexter"
  url "https://github.com/ankane/dexter/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "cd8d08f8a89874c832fc6a53f9020dc9843d0717810870a1b8eecb3246b889bf"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3b44545e99974f4afd0f172e80ab95cd796ff6f732d0bd7557927b1fa121e85a"
    sha256 cellar: :any,                 arm64_sonoma:  "e5f365b4cb8545f4d317eca8d2bdb5b546ce69eb44ee9433b020e0eefd7fb53c"
    sha256 cellar: :any,                 arm64_ventura: "7c5e9f9fa3e600fcd38446429359c6f83e1d3042bc76abc418d0054e79006a4f"
    sha256 cellar: :any,                 sonoma:        "9a1e462de74bf97479e797f1c33ed097e1778a34177911c5ede0670f33e697d5"
    sha256 cellar: :any,                 ventura:       "7911fc88a74ed976ac31abeb31cd7e0dd636c4e54b5c7003dceb4df1480b8d4a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fcc524b51ce4c16b514d725bddc0f2751c4f025d07852efd32dba397bfeb5f15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6197ab94a5a3f9a335611eb148ea6f99bb31269979cb5f2046a062237f377d26"
  end

  depends_on "postgresql@17" => :test
  depends_on "libpq"
  depends_on "ruby"

  resource "google-protobuf" do
    url "https://rubygems.org/gems/google-protobuf-4.31.1.gem"
    sha256 "022bc82931a0860a7f2ace41bd48e904c8e65032c1d5eefc33294b5edf9741f8"
  end

  resource "pg" do
    url "https://rubygems.org/gems/pg-1.5.9.gem"
    sha256 "761efbdf73b66516f0c26fcbe6515dc7500c3f0aa1a1b853feae245433c64fdc"
  end

  resource "pg_query" do
    url "https://rubygems.org/gems/pg_query-6.1.0.gem"
    sha256 "8b005229e209f12c5887c34c60d0eb2a241953b9475b53a9840d24578532481e"
  end

  resource "slop" do
    url "https://rubygems.org/gems/slop-4.10.1.gem"
    sha256 "844322b5ffcf17ed4815fdb173b04a20dd82b4fd93e3744c88c8fafea696d9c7"
  end

  def install
    ENV["GEM_HOME"] = libexec
    ENV["PG_CONFIG"] = Formula["libpq"].opt_bin/"pg_config"

    resources.each do |r|
      r.fetch
      system "gem", "install", r.cached_download, "--ignore-dependencies",
             "--no-document", "--install-dir", libexec
    end

    system "gem", "build", "pgdexter.gemspec"
    system "gem", "install", "--ignore-dependencies", "pgdexter-#{version}.gem"

    bin.install libexec/"bin/dexter"
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
      output = shell_output("#{bin}/dexter -d postgres -p #{port} -s SELECT 1 2>&1", 1)
      assert_match "Install HypoPG", output
    ensure
      system pg_ctl, "stop", "-D", testpath/"test"
    end
  end
end
