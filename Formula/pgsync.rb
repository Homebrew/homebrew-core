class Pgsync < Formula
  desc "Sync Postgres data between databases"
  homepage "https://github.com/ankane/pgsync"
  url "https://github.com/ankane/pgsync/archive/v0.7.4.tar.gz"
  sha256 "0d8c0d319374f658a8aacafb15edbc074328aaec503fa92aae6032d3e1f12e60"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "2dfb0ba78422a71258c0046a1c59e433a7c70fd98e8564494b8878624e056756"
    sha256                               arm64_monterey: "169345dc69a037d36dac2f0d54ffd229236bd62c86c97f85f07cced38f8c7f65"
    sha256                               arm64_big_sur:  "c3dd3f2937b118494d0002e08fd95ec0959b982396d9f3008d24f7ba05d84fec"
    sha256                               ventura:        "c621ec145ac0bb5ba6297e2b24ee351c418e8144bc6d18c178c5a27c3e431a26"
    sha256                               monterey:       "8f1be82ef9f91002531609773443d58aea9bfb0bd11e6979f7944680960e860e"
    sha256                               big_sur:        "a38c199ddfda5b26938988cb5f575669e3bb0748c045ca5d49da6774988a09b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a6884e6e6c1ed462f3d06a42a2f1c3babfe12e25b9ae784f0072420b7c00344"
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
