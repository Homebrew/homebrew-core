class Pgsync < Formula
  desc "Sync Postgres data between databases"
  homepage "https://github.com/ankane/pgsync"
  url "https://github.com/ankane/pgsync/archive/v0.7.2.tar.gz"
  sha256 "1c6adcd9f3bd145f573d80dfde06cb83e0ce3653492d9ae767493abf541c469c"
  license "MIT"

  bottle do
    sha256                               arm64_monterey: "15e8a9d23d340aeb0cb1bb198f7bfdc7d60dfb60b42b942d7c43e529da775fc9"
    sha256                               arm64_big_sur:  "0c1bfbbe1d3e56109f8edf2d431940fc84debb9f20e1de3021eeb2ea671e7690"
    sha256                               monterey:       "eecfe3e70e650c26a8342d5e3208b763cd4a3bd3dc02e48d449493693de37c02"
    sha256                               big_sur:        "56215ee5262ef7da1a9914e57d18ed7808cbb16414f45b9e67c1d341a263c54b"
    sha256                               catalina:       "bccffa68eae31f5e350c1095c67febfcc49bb859619cadded76ecc1961e285d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d70c710f2849f5a39d6d5759d0cb358cc79e190aaef1625c97686ab980d176c"
  end

  depends_on "libpq"

  uses_from_macos "ruby"

  resource "parallel" do
    url "https://rubygems.org/gems/parallel-1.22.1.gem"
    sha256 "ebdf1f0c51f182df38522f70ba770214940bef998cdb6e00f36492b29699761f"
  end

  resource "pg" do
    url "https://rubygems.org/gems/pg-1.4.4.gem"
    sha256 "a3877f06e3548a01ffdeb1c1c8cc751db6e759c0020b133a54cbdb0e71fa4525"
  end

  resource "slop" do
    url "https://rubygems.org/gems/slop-4.9.3.gem"
    sha256 "6e26dfdb549f45d75f5f843f4c1b6267f34b6604ca8303086946f97ff275e933"
  end

  resource "tty-cursor" do
    url "https://rubygems.org/gems/tty-cursor-0.7.1.gem"
    sha256 "79534185e6a777888d88628b14b6a1fdf5154a603f285f80b1753e1908e0bf48"
  end

  resource "tty-spinner" do
    url "https://rubygems.org/gems/tty-spinner-0.9.3.gem"
    sha256 "0e036f047b4ffb61f2aa45f5a770ec00b4d04130531558a94bfc5b192b570542"
  end

  def install
    ENV["GEM_HOME"] = libexec
    ENV["PG_CONFIG"] = Formula["libpq"].opt_bin/"pg_config"

    resources.each do |r|
      r.fetch
      system "gem", "install", r.cached_download, "--ignore-dependencies",
             "--no-document", "--install-dir", libexec
    end

    system "gem", "build", "pgsync.gemspec"
    system "gem", "install", "--ignore-dependencies", "pgsync-#{version}.gem"

    bin.install libexec/"bin/pgsync"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    system bin/"pgsync", "--init"
    assert_predicate testpath/".pgsync.yml", :exist?
  end
end
