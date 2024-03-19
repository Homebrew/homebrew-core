class Dexter < Formula
  desc "Automatic indexer for Postgres"
  homepage "https://github.com/ankane/dexter"
  url "https://github.com/ankane/dexter/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "d17a738e0535c5796565b2a6abb20756d9db2f0eb0b6e29db75f7299e5d78852"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1c00f4069c2de269367c645c3a1c5695307162419ea7cbaff7f95eff42fe2d41"
    sha256 cellar: :any,                 arm64_ventura:  "21b8fc9de026808a4d22997f60dda83a5903d06959b96740d778a8dbb75a99bd"
    sha256 cellar: :any,                 arm64_monterey: "da1d2e82b7b2f3d0af88d5adf8983724b35a26669ac050bfbf3198b201d6126e"
    sha256 cellar: :any,                 sonoma:         "06d10028b32925cde0f7f28ab3fb90e660899e21e8da22f52a33cb3202809fd5"
    sha256 cellar: :any,                 ventura:        "b1811b2b4ea0ff2d99f83f8258f4739b0df625b2e0290cf48856126d6c972dfd"
    sha256 cellar: :any,                 monterey:       "d38d1ecf27ca221a027615379e748b0d7db4558e2ad3cc3f79f2ecb7534fa37f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3344c6864de89d055b9baa5b014ed85c9e1abe3ee95a1e94149067690313f4bb"
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
