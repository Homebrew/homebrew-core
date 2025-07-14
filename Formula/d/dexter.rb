class Dexter < Formula
  desc "Automatic indexer for Postgres"
  homepage "https://github.com/ankane/dexter"
  url "https://github.com/ankane/dexter/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "77b9d2b28689dfd3b2a16c94ef8e20bf16cd0bf4dcc62b6d350ee8257d0763db"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4b4ad039afe5f9b48429c2d50e4ca30224fd82c3dbfaa1a7843ca9dc2b5c2432"
    sha256 cellar: :any,                 arm64_sonoma:  "dec08b0fb0f9233d8bc8692ff769ea4b03c11e57085bb90f6f9e5beaf782d616"
    sha256 cellar: :any,                 arm64_ventura: "2db2a0c8e07402ec5d910c9371df29ba0bd4c59569e637d0a3ffa571bd40cf3a"
    sha256 cellar: :any,                 sonoma:        "bd98ab1b3b0f931280837dc6c2f0019805fc14e4d0c31a536127dd4d816fae2c"
    sha256 cellar: :any,                 ventura:       "009dc556a400c7271ff4e38dff366f7992d9eb2f0be9baafdb2795a144a28199"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e87914d4f018246f9aa0cc543ef5a60205ecd1ccdac5b8af4bb1e37365a89be9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5b328c1a61290206f7ea433b1002c950c82137beb342391e5dd28ab2ba5c0f7"
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
