class Pgsync < Formula
  desc "Sync Postgres data between databases"
  homepage "https://github.com/ankane/pgsync"
  url "https://github.com/ankane/pgsync/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "385aa0be8683ae4877fc6b39a3a4a0664680ed1631559fadd7b5113d7724ecea"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "943687f8e9f670920d7eeaee1a271cdc66d6433010d03375832e12478755ab1f"
    sha256 cellar: :any,                 arm64_sonoma:   "d0fca0241bcd1370d86a97de70e9a6255eb8233e732da09777c2b5894c493374"
    sha256 cellar: :any,                 arm64_ventura:  "cf0802b4607cd6561a44ab652c5d6fcee8606d30ee2ab26fd6dc173a2861b225"
    sha256 cellar: :any,                 arm64_monterey: "140280805ff038e3ac4acaebe412c00cefc83ab4ead853f4ae118df3ce9ec1cd"
    sha256 cellar: :any,                 sonoma:         "11f63bba4caf4667f0932a4478b35796c149f6abb6123cb52ca5f9cd9d6fad29"
    sha256 cellar: :any,                 ventura:        "4266dc4941f0a59b6501366328621230140dca93095da411ca59b295864264be"
    sha256 cellar: :any,                 monterey:       "685537766509336ec0a61b47a202c279303740e6284ecf85e31a20dfc9a91d28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be09e2268832219f7fe75c3dcb8c0baf0067cee5a80c325f423f07ab788fba29"
  end

  depends_on "libpq"
  depends_on "ruby"

  resource "parallel" do
    url "https://rubygems.org/gems/parallel-1.25.1.gem"
    sha256 "12e089b9aa36ea2343f6e93f18cfcebd031798253db8260590d26a7f70b1ab90"
  end

  resource "pg" do
    url "https://rubygems.org/gems/pg-1.5.6.gem"
    sha256 "4bc3ad2438825eea68457373555e3fd4ea1a82027b8a6be98ef57c0d57292b1c"
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
