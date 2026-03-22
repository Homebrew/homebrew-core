class Pgslice < Formula
  desc "Postgres partitioning as easy as pie"
  homepage "https://github.com/ankane/pgslice"
  url "https://github.com/ankane/pgslice/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "8c028497e33be976c7431fbd7d4f5b2318422ffd99625f7aa5c8dcf664179d51"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "11819b8c5a090be57c1d7122e5fc3462159fb7190e1ca5610f7e7eb637f7bebe"
    sha256 cellar: :any,                 arm64_sequoia: "8f8dba8973d4a01f2fe35dec6df26d676f87078d7ca8ea3d709a3c2166eedcf2"
    sha256 cellar: :any,                 arm64_sonoma:  "35e77ea0148bd8ffd8f0d5116af8fb842dd20a2178f95e45ca01e0b2c7724217"
    sha256 cellar: :any,                 sonoma:        "9fb2970a1336b2488378de8c6e291a5c63d7468b7c4635895ba96d89e8a6e6be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78b9262b02cb4a3124062fa362d07bbadfb86110c4c00a7b081a20d43a2f070d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8416b778ccc3f5aa00631ddfc2f76957efd54b39fc22273edadf9c461a9892c5"
  end

  depends_on "postgresql@18" => :test
  depends_on "libpq"
  depends_on "ruby"

  # List with `gem install --explain pgslice -v #{version}`
  # https://rubygems.org/gems/pgslice/versions/#{version}/dependencies

  resource "thor" do
    url "https://rubygems.org/gems/thor-1.4.0.gem"
    sha256 "8763e822ccb0f1d7bee88cde131b19a65606657b847cc7b7b4b82e772bcd8a3d"
  end

  resource "pg" do
    url "https://rubygems.org/gems/pg-1.6.3.gem"
    sha256 "1388d0563e13d2758c1089e35e973a3249e955c659592d10e5b77c468f628a99"
  end

  resource "cgi" do
    url "https://rubygems.org/gems/cgi-0.5.1.gem"
    sha256 "e93fcafc69b8a934fe1e6146121fa35430efa8b4a4047c4893764067036f18e9"
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
