class Pgsync < Formula
  desc "Sync Postgres data between databases"
  homepage "https://github.com/ankane/pgsync"
  url "https://github.com/ankane/pgsync/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "485c38e4c5bfec943bf8781f8c8ca4b773011c5767fb30be44d373566f40d5dc"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1f6a6e2b970a24e8d4de77f9c1e9adfd8285fbab0bfcf279e66b99b833a03530"
    sha256 cellar: :any,                 arm64_sequoia: "4cdc2bb0bfcfc0f306696026ed00a5025c11d34a04e6787541782ca0b47dd543"
    sha256 cellar: :any,                 arm64_sonoma:  "ce5c0f2b05b9f7380714773e17635bf35327defda51c519e751832eeff86cb76"
    sha256 cellar: :any,                 sonoma:        "25aa2a324078445ed8e7089b0f990804b6f403a31a6e8f0be2608c777f9ea0cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d5d706c169092ca88d882c52ad3b86c572182e51a41a86b01fa7747ba9b131d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ef4fcfe0b023ae63a909b42006fc3305f72695eec74256c47ef7729a8808057"
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
