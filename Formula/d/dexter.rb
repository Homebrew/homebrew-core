class Dexter < Formula
  desc "Automatic indexer for Postgres"
  homepage "https://github.com/ankane/dexter"
  url "https://github.com/ankane/dexter/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "4c77f60f136d0523d08957486227558d041d5a2a9ca4f51fcd5e427e9aa39581"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2e57a40896c238f17fab38fab34c7b6f410d60e8b69ddbea18e5608dbfe7f7cd"
    sha256 cellar: :any,                 arm64_ventura:  "6f08f8ee24290f706852c9590081b4a485271086910def2879f527c5e16be85c"
    sha256 cellar: :any,                 arm64_monterey: "28c220582e858e84fbbfddaaa669c23fb055d4131b02db0194280f459423ebc7"
    sha256 cellar: :any,                 sonoma:         "8f7dcc3572da9e65550c636ab9022db03a283dd4b216e8d8a1b0d87477e69d70"
    sha256 cellar: :any,                 ventura:        "e0ddeea2c9733f2abe0f3e85e1b7baf7175c53743e13689836ac591d7b00f335"
    sha256 cellar: :any,                 monterey:       "afaa61bd8f7a8b6c389190c3b0d9fa2a851122f3f58a732a0d1ea348b44307c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84fe0f031b932361f58f5f44dd12cba5ce1bee211d46eae3a11543d07771db43"
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
    url "https://rubygems.org/gems/pg_query-4.2.3.gem"
    sha256 "1cc9955c7bce8e51e1abc11f1952e3d9d0f1cd4c16c58c56ec75d5aaf1cfd697"
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
