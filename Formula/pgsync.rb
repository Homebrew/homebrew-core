class Pgsync < Formula
  desc "Sync Postgres data between databases"
  homepage "https://github.com/ankane/pgsync"
  url "https://github.com/ankane/pgsync/archive/v0.7.4.tar.gz"
  sha256 "0d8c0d319374f658a8aacafb15edbc074328aaec503fa92aae6032d3e1f12e60"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "d1e1f2222f90e61de8734634c95ba9a827e69d19f42a5fc3b35cea757ed33192"
    sha256                               arm64_monterey: "65a64594047d853f3521a9df8531daa6a5a267997183138241285af11e75f567"
    sha256                               arm64_big_sur:  "e2c3459dcabb4fa25ec7180a5b0e28d5c926204eda322f19e09e35b3eed383d1"
    sha256                               ventura:        "df290f2de349e3c2e409220be2f4c8b49248454c589d59f80dc942b152e5b5f1"
    sha256                               monterey:       "984d3269acf9e81069269efd228a6c6005527ba25719dd7cebaa37784b1d1289"
    sha256                               big_sur:        "98498d42a544c430b9fa30c219c1b783c66fa68d79b08ad30e23d20173136a8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5783edd9237dd34e39a2f67be2976e2929f5febd16981cda3ab26677ca2bb169"
  end

  depends_on "libpq"

  uses_from_macos "ruby"

  resource "parallel" do
    url "https://rubygems.org/gems/parallel-1.22.1.gem"
    sha256 "ebdf1f0c51f182df38522f70ba770214940bef998cdb6e00f36492b29699761f"
  end

  resource "pg" do
    url "https://rubygems.org/gems/pg-1.4.6.gem"
    sha256 "d98f3dcb4a6ae29780a2219340cb0e55dbafbb7eb4ccc2b99f892f2569a7a61e"
  end

  resource "slop" do
    url "https://rubygems.org/gems/slop-4.10.1.gem"
    sha256 "844322b5ffcf17ed4815fdb173b04a20dd82b4fd93e3744c88c8fafea696d9c7"
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
