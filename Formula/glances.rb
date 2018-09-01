class Glances < Formula
  desc "Alternative to top/htop"
  homepage "https://nicolargo.github.io/glances/"
  url "https://github.com/nicolargo/glances/archive/v3.0.tar.gz"
  sha256 "7428ed7c598b5d9ee464dd20c06f58df62e398fe7daf6596933a656f72bee1ba"

  bottle do
    cellar :any_skip_relocation
    sha256 "5a93b668695a9ac72f2307aeba8ca4d37eaaa33ec5e3726bcb2317d79fa84de3" => :mojave
    sha256 "ff4cdbbf531f93187e9b32047ce0ce33b9fe25d3d689bd475303b3ce5a0634c5" => :high_sierra
    sha256 "bfdfdacd387c866e575bc05febd92e131097856b54e3d24f4db84450ddab2508" => :sierra
    sha256 "03cb45f3f3333af6789292890b1a2ea23825a3a77f02f3ebf735c90708818166" => :el_capitan
  end

  depends_on "python@2"

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/7d/9a/1e93d41708f8ed2b564395edfa3389f0fd6d567597401c2e5e2775118d8b/psutil-5.4.7.tar.gz"
    sha256 "5b6322b167a5ba0c5463b4d30dfd379cd4ce245a1162ebf8fc7ab5c5ffae4f3b"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resource("psutil").stage do
      system "python", *Language::Python.setup_install_args(libexec/"vendor")
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])

    prefix.install libexec/"share"
  end

  test do
    begin
      read, write = IO.pipe
      pid = fork do
        exec bin/"glances", "-q", "--export-csv", "/dev/stdout", :out => write
      end
      header = read.gets
      assert_match "timestamp", header
    ensure
      Process.kill("TERM", pid)
    end
  end
end
