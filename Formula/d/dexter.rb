class Dexter < Formula
  desc "Automatic indexer for Postgres"
  homepage "https://github.com/ankane/dexter"
  url "https://github.com/ankane/dexter/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "d17a738e0535c5796565b2a6abb20756d9db2f0eb0b6e29db75f7299e5d78852"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b55d0944aa8da78137b097693aaaea3f29922170c3da4799336757ca0fe3e938"
    sha256 cellar: :any,                 arm64_ventura:  "d7f7611fb52ec96e542330f3d1aa3d42411e20fcc2712ca9a517b33e6e48b98a"
    sha256 cellar: :any,                 arm64_monterey: "239f1f376e72308cdb66f9bf08b1978c0797593c1d778b195fd38ad98748c0fb"
    sha256 cellar: :any,                 sonoma:         "bccc57883ac12bc125ab81556c55f8c34b6ef448bf8240f7ffa415117bc58717"
    sha256 cellar: :any,                 ventura:        "2840160ab8765e516538b3d4a1580317eaa267a40d4e267cbbc3cc54dd16ce00"
    sha256 cellar: :any,                 monterey:       "6db24b45a034ce3fa6c29df0254f1d7aec55f29f7af531a196122343fc5cae9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84bd353c1fdba99ecf9b7c6bcf7819b46da8ea128942760732f9028fc16f4668"
  end

  depends_on "postgresql@16" => :test
  depends_on "libpq"
  depends_on "ruby"

  resource "google-protobuf" do
    url "https://rubygems.org/gems/google-protobuf-3.25.3.gem"
    sha256 "39bd97cbc7631905e76cdf8f1bf3dda1c3d05200d7e23f575aced78930fbddd6"
  end

  resource "pg" do
    url "https://rubygems.org/gems/pg-1.5.6.gem"
    sha256 "4bc3ad2438825eea68457373555e3fd4ea1a82027b8a6be98ef57c0d57292b1c"
  end

  resource "pg_query" do
    url "https://rubygems.org/gems/pg_query-4.2.3.gem"
    sha256 "1cc9955c7bce8e51e1abc11f1952e3d9d0f1cd4c16c58c56ec75d5aaf1cfd697"
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

    postgresql = Formula["postgresql@16"]
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
