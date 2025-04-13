class Dexter < Formula
  desc "Automatic indexer for Postgres"
  homepage "https://github.com/ankane/dexter"
  url "https://github.com/ankane/dexter/archive/refs/tags/v0.5.6.tar.gz"
  sha256 "f2bebde21f8f06f726e6c16cd932afa8fe42714012f3ce53b4e0355b7cb91628"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "37a406d94e604468c6bd45f08225600fc3a929c38cdafbbcb6b0d1e73f833873"
    sha256 cellar: :any,                 arm64_sonoma:  "096fe52ac18aab6b6c77f98cd4b0ce92a9501b5759095a1d85a06394c8590531"
    sha256 cellar: :any,                 arm64_ventura: "6a409cba5aeaff176b666c1cd2e9b53deaa704b5a1b46a3fe697703d8df302bb"
    sha256 cellar: :any,                 sonoma:        "3b9d57da475b9026fc2e469f6a442d1acd744192e817fb46086def143d75b5b5"
    sha256 cellar: :any,                 ventura:       "f21626ffdfeb5712eee1d1d6d311eb29c1bb6bf5e15a74de726628b4204474be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "20acd2b97f4698c0105d2dbcd5778f7adddb4336f9a1715911d2fc5e8bbda66e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c769be717ed914c7552d0aaccff2e9d53171f256ac7c9d9bbad0afa40b4bbaf8"
  end

  depends_on "postgresql@17" => :test
  depends_on "libpq"
  depends_on "ruby"

  resource "google-protobuf" do
    url "https://rubygems.org/gems/google-protobuf-4.29.3.gem"
    sha256 "9a5576c0059f57d7e07107bda8287ac14d0c59c71fe939b260855d3f46b9b566"
  end

  resource "pg" do
    url "https://rubygems.org/gems/pg-1.5.9.gem"
    sha256 "761efbdf73b66516f0c26fcbe6515dc7500c3f0aa1a1b853feae245433c64fdc"
  end

  resource "pg_query" do
    url "https://rubygems.org/gems/pg_query-6.0.0.gem"
    sha256 "fbf09a4e900cee1d61e2bbfda1fefdbc35bc83c5f1c7ae1be1c6ffc5ae0f5c04"
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
