class Dexter < Formula
  desc "Automatic indexer for Postgres"
  homepage "https://github.com/ankane/dexter"
  url "https://github.com/ankane/dexter/archive/refs/tags/v0.6.3.tar.gz"
  sha256 "5aca9fcb671170bda6ae8a9b6d563a4813237412a658f614bb48c8caf6067f78"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "002eaa9abec0185a976061ea1bcbc43ac93b005abe2f0afe95d68ff35ce16401"
    sha256 cellar: :any,                 arm64_sequoia: "4232cde75daa84becfd6be67644d621301640236f75c110fba05dc7517d65dbf"
    sha256 cellar: :any,                 arm64_sonoma:  "6e143bf7c3c27e1588f54c19fa8d64c03985dfeede602504eb9dbd8dda226acf"
    sha256 cellar: :any,                 sonoma:        "1b262e7f9be04b0c9330131c4263d98471cde13716a926792b19d18a1c23e911"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26b4415aee5ac9ef0b7a2b307dce6527acf1de19e6d48bc077ecf68f6c73f119"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f0865d3289eaed64f068774d063bd8d084f08d6db09caac95539572e9ef3402"
  end

  depends_on "postgresql@18" => :test
  depends_on "libpq"
  depends_on "ruby"

  resource "google-protobuf" do
    url "https://rubygems.org/gems/google-protobuf-4.33.0.gem"
    sha256 "a4918b45bea5889c38fb82da83a5175209600f9c17fb1698be30d635696b3526"
  end

  resource "pg" do
    url "https://rubygems.org/gems/pg-1.6.2.gem"
    sha256 "58614afd405cc9c2c9e15bffe8432e0d6cfc58b722344ad4a47c73a85189c875"
  end

  resource "pg_query" do
    url "https://rubygems.org/gems/pg_query-6.1.0.gem"
    sha256 "8b005229e209f12c5887c34c60d0eb2a241953b9475b53a9840d24578532481e"
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

    postgresql = Formula["postgresql@18"]
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
