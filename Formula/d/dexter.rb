class Dexter < Formula
  desc "Automatic indexer for Postgres"
  homepage "https://github.com/ankane/dexter"
  url "https://github.com/ankane/dexter/archive/refs/tags/v0.5.5.tar.gz"
  sha256 "4e5c7a8e1e77af44e16fefe2dcb5fc221612be0b6977547318edd9e597467e19"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "f750ffc4abb7b8ca1bf4a905d0e06e171ac2c8743ec65a5a09604f766be2c97d"
    sha256 cellar: :any,                 arm64_sonoma:   "07dfc1189a60ac1210ac45c70ee560e25c75e6f86d95f6fe131f03b9ecc98c35"
    sha256 cellar: :any,                 arm64_ventura:  "07c027d2438d2fa87d3f09491a954fc7c9d026492f190c66bba029299c9bd981"
    sha256 cellar: :any,                 arm64_monterey: "56e53e4eadefa9f678cfdf514c5c6339f5f0a40cb603fa1fe801228fe722ded0"
    sha256 cellar: :any,                 sonoma:         "4f345df259c4688e07a37ab44b48359d59193bdacefad9dd2753e762dd1be89d"
    sha256 cellar: :any,                 ventura:        "a06551e518d503c32d122f19f5f7d6d3be18983c666cc42d7c6b67a87ecc2f22"
    sha256 cellar: :any,                 monterey:       "79925df614a0853a3606ea89b28f563958688d736419958c7c82e63ce7308950"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83130e9cf8066ce05ff78a2e893da336cc2d5225b20be91a9746a43f3a2bcc65"
  end

  depends_on "postgresql@16" => :test
  depends_on "libpq"
  depends_on "ruby"

  resource "google-protobuf" do
    url "https://rubygems.org/gems/google-protobuf-3.25.3.gem"
    sha256 "39bd97cbc7631905e76cdf8f1bf3dda1c3d05200d7e23f575aced78930fbddd6"
  end

  resource "pg" do
    url "https://rubygems.org/gems/pg-1.5.6.gem"
    sha256 "4bc3ad2438825eea68457373555e3fd4ea1a82027b8a6be98ef57c0d57292b1c"
  end

  resource "pg_query" do
    url "https://rubygems.org/gems/pg_query-5.1.0.gem"
    sha256 "b7f7f47c864f08ccbed46a8244906fb6ee77ee344fd27250717963928c93145d"
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

    postgresql = Formula["postgresql@16"]
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
