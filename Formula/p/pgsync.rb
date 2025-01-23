class Pgsync < Formula
  desc "Sync Postgres data between databases"
  homepage "https://github.com/ankane/pgsync"
  url "https://github.com/ankane/pgsync/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "385aa0be8683ae4877fc6b39a3a4a0664680ed1631559fadd7b5113d7724ecea"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d569525a961f1543642f07928fe0ca9317ac819c670a7f6d6735d8752168bac6"
    sha256 cellar: :any,                 arm64_sonoma:  "95f8e9b647da0ca010fe39d6f289e64e849b25f212f0e50fb7906e3a88e854fe"
    sha256 cellar: :any,                 arm64_ventura: "c3fe3a0ab9336a9fd3343e1466ba5a137294d2ffbae99110adb2e2c152f1e206"
    sha256 cellar: :any,                 sonoma:        "0b1082fa75fb757eea994e9d50be3116d701587c5880430fb20d3a018b875a3d"
    sha256 cellar: :any,                 ventura:       "01e1f89f86a1cb51e8c4821a98611c5bad2f18d7145c82e39498d474af9af87c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce4b49836360a1abe20cd60228f4e555765a5e41483709706584931abb6dd64d"
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
