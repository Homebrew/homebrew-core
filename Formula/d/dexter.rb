class Dexter < Formula
  desc "Automatic indexer for Postgres"
  homepage "https://github.com/ankane/dexter"
  url "https://github.com/ankane/dexter/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "481f914ead1e7ad1c2a83df111d6ebfa8d23e48119c35e57fff6649bbb27379e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "37c20ff1fec46e21f4c5bd004c61badbc14ebc10765c5c4566e4ac20e42a61cd"
    sha256 cellar: :any,                 arm64_sequoia: "8b1ad41e59a62ca16baeb8128642e61fbc44ff2c83b3a3a2987611285550c0c9"
    sha256 cellar: :any,                 arm64_sonoma:  "8c395f21bb1692a2c181840488acac9bcd6ccbc55f00a89328412add8e823cdd"
    sha256 cellar: :any,                 arm64_ventura: "69d9fc12c4d4fcbb92b2c67db6a08bd4682573fbbfdc38146d2561be30d6795a"
    sha256 cellar: :any,                 sonoma:        "55f54266dcd153ee27c97cad0771a32b8d084c4d8e835b3f651bd5bf530e9967"
    sha256 cellar: :any,                 ventura:       "3bff76ebfc0eaa45ee0f9b3ab45e5fd2936c28377983a25c2ee43021233bf1d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c3e7915f422caa0136e50528326088c71caf154c1266eb9c7527f203d8bfeca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25f60887e53b0ee6efcf578c4a5bb4854120320b638e2f3f4b774016449224ef"
  end

  depends_on "postgresql@17" => :test
  depends_on "libpq"
  depends_on "ruby"

  resource "google-protobuf" do
    url "https://rubygems.org/gems/google-protobuf-4.31.1.gem"
    sha256 "022bc82931a0860a7f2ace41bd48e904c8e65032c1d5eefc33294b5edf9741f8"
  end

  resource "pg" do
    url "https://rubygems.org/gems/pg-1.6.0.gem"
    sha256 "26ea1694e4ed2e387a8292373acbb62ff9696d691d3a1b8b76cf56eb1d9bd40b"
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
