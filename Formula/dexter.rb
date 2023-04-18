class Dexter < Formula
  desc "Automatic indexer for Postgres"
  homepage "https://github.com/ankane/dexter"
  url "https://github.com/ankane/dexter/archive/v0.4.3.tar.gz"
  sha256 "68d840020c87b5792ab9eb3e12939cf3b5944427c1e28cf8a34d5737223de2a0"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "f5fbf96a1cc3b83156c12309a494bf209ca7cee48038a58d130984139040fe10"
    sha256                               arm64_monterey: "1062799e459bf363ee8248ec0428601e0a2a0d36bf64bbaeb22ad3317b19c09d"
    sha256                               arm64_big_sur:  "29b7858b15990bade00c2b4dfef64227ceebc39d076e94986e892a23557ae3c5"
    sha256                               ventura:        "7b49affac916be707608a9cc5de40a83f22db0ad05333eb0c634acd6e1c5852c"
    sha256                               monterey:       "9374f5d5a343a2f200df6ca84466cd0ccd7dba165f36cf84923b1f2000eba6a0"
    sha256                               big_sur:        "720f746d14dd9624f058aad44293b95b91cece439c705fcd60fbdd9b1d2d11df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0f4ef3dfed58f27327afb4b700c45cdf93d57a27c3f21ac57780b23cdbc8037"
  end

  depends_on "postgresql@15" => :test
  depends_on "libpq"

  uses_from_macos "ruby"

  resource "google-protobuf" do
    url "https://rubygems.org/gems/google-protobuf-3.22.2.gem"
    sha256 "d516c13248500fb4e1af469c2d71e8b6ecffacb6f55e9be203f01b7d0ff01eff"
  end

  resource "pg" do
    url "https://rubygems.org/gems/pg-1.4.6.gem"
    sha256 "d98f3dcb4a6ae29780a2219340cb0e55dbafbb7eb4ccc2b99f892f2569a7a61e"
  end

  resource "pg_query" do
    url "https://rubygems.org/gems/pg_query-2.2.1.gem"
    sha256 "6086972bbf4eab86d8425b35f14ca8b6fe41e4341423582801c1ec86ff5f8cea"
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

    postgresql = Formula["postgresql@15"]
    pg_ctl = postgresql.opt_bin/"pg_ctl"
    port = free_port

    system pg_ctl, "initdb", "-D", testpath/"test"
    (testpath/"test/postgresql.conf").write <<~EOS, mode: "a+"
      port = #{port}
    EOS
    system pg_ctl, "start", "-D", testpath/"test", "-l", testpath/"log"

    begin
      output = shell_output("#{bin}/dexter -d postgres -p #{port} -s SELECT 1 2>&1", 1)
      assert_match 'extension "hypopg" is not available', output
    ensure
      system pg_ctl, "stop", "-D", testpath/"test"
    end
  end
end
