class Dexter < Formula
  desc "Automatic indexer for Postgres"
  homepage "https://github.com/ankane/dexter"
  url "https://github.com/ankane/dexter/archive/v0.5.0.tar.gz"
  sha256 "bc50758bd06c25b9042c48274b4bbda79bd8bf715b86c390e2bf077f54f12776"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c5a9245b1c686e1fcbfa1b39420de21ef91aa3d52d758fa3c7a7bebd877c8bd1"
    sha256 cellar: :any,                 arm64_monterey: "deeb9ef39b6cd14b2d944ab3ce96576bf7ed46f899383b44b4dc4268a506499e"
    sha256 cellar: :any,                 arm64_big_sur:  "da7670a561caf0b12daede67c212a107072ae14d739d435a8b305e835c5599c8"
    sha256 cellar: :any,                 ventura:        "a709925d5ba131a7bc1b3081664fe9ccabdc9ee67b14ed46650557529c305235"
    sha256 cellar: :any,                 monterey:       "6d466ebc3971b3ffcf312ae7499737b4294c50ff1c299f15aee39155d98b6d36"
    sha256 cellar: :any,                 big_sur:        "08f56f87222a86645ff52af4bc041a1ff0152eff98b1403389e8ac19cfdf7e28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f833dbfce77ac84caa418a10d61afc5c04e307d6c783bf42d160d79a2e5e6562"
  end

  depends_on "postgresql@15" => :test
  depends_on "libpq"
  depends_on "ruby"

  resource "google-protobuf" do
    url "https://rubygems.org/gems/google-protobuf-3.22.3.gem"
    sha256 "09db2a54fcdf2c8ec04d2c10b2818fd6ee0990578317b42e839811f2fd288ff5"
  end

  resource "pg" do
    url "https://rubygems.org/gems/pg-1.4.6.gem"
    sha256 "d98f3dcb4a6ae29780a2219340cb0e55dbafbb7eb4ccc2b99f892f2569a7a61e"
  end

  resource "pg_query" do
    url "https://rubygems.org/gems/pg_query-4.2.0.gem"
    sha256 "ab3059025d9f0471004b12036ad272e0147f1d4ddbab011dd96075c0abce899f"
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

    postgresql = Formula["postgresql@15"]
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
