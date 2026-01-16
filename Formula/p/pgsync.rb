class Pgsync < Formula
  desc "Sync Postgres data between databases"
  homepage "https://github.com/ankane/pgsync"
  url "https://github.com/ankane/pgsync/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "485c38e4c5bfec943bf8781f8c8ca4b773011c5767fb30be44d373566f40d5dc"
  license "MIT"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fe769a833d393d4a1a2d14e5ec710ce30ba26100f26c7de7afe3070772f92406"
    sha256 cellar: :any,                 arm64_sequoia: "5799a23728b227d10d0b8502f3e16d911d77da00466cc5e70acfc53b51822cd8"
    sha256 cellar: :any,                 arm64_sonoma:  "59dfc0e99d2e655745377685522d88f6fbe0f49e0c8646ae17377d4c0255bc29"
    sha256 cellar: :any,                 sonoma:        "892cb4b2ca7209d33bf1c80d44e71c4b5e6c91000ff3bd719612dbb281bd6fd9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9596851af03225d8b7b43404b9cca41330948a7db7eb79601f4bde1c4a5f72ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57b9865d679544372d9bd0dabbb86025790c1a8f401e00a9251352f0b4a8a004"
  end

  depends_on "libpq"
  depends_on "ruby"

  resource "parallel" do
    url "https://rubygems.org/gems/parallel-1.27.0.gem"
    sha256 "4ac151e1806b755fb4e2dc2332cbf0e54f2e24ba821ff2d3dcf86bf6dc4ae130"
  end

  resource "pg" do
    url "https://rubygems.org/gems/pg-1.6.2.gem"
    sha256 "58614afd405cc9c2c9e15bffe8432e0d6cfc58b722344ad4a47c73a85189c875"
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
    assert_path_exists testpath/".pgsync.yml"
  end
end
