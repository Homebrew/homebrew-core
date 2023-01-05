class Pgsync < Formula
  desc "Sync Postgres data between databases"
  homepage "https://github.com/ankane/pgsync"
  url "https://github.com/ankane/pgsync/archive/v0.7.3.tar.gz"
  sha256 "95913d6077dec326dea16ef8910faaf62fbed3cd92d4f0d2b6a4bc7eefa99680"
  license "MIT"
  revision 1

  bottle do
    sha256                               arm64_ventura:  "4cd172793979fd2ac562fd95818b4e5010a18535aacab4384d2ae71437e15c99"
    sha256                               arm64_monterey: "d187674c50b563f9e25229fd21bc87da94417658b7d7160be4165e3179855f45"
    sha256                               arm64_big_sur:  "ba6666d65b53adec240851ab0ae99a25bc056e9927f9ef05890af14164602b3f"
    sha256                               ventura:        "0ff3b44272aba0a3cafcf280b8fe6de1a6bf8a27413bf9c1d7cc5ef2ef8cae26"
    sha256                               monterey:       "3f77099f18c937132cac897e7bca7461c40d6a4a69d7a59ed51122cd451646ba"
    sha256                               big_sur:        "235552086ef38602a102e86f09d3625d7a86fd74df3b0394a008387a9f784f37"
    sha256                               catalina:       "e135ab9d372ef1d88056d2fc271937c8053461c6a1ef74c784681731b5b8be4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7989a07e0d1e2f65087509a1b5f4b859bc41ca225e1fb2efdb4e8e9f200cb087"
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
