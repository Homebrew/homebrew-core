class Glances < Formula
  desc "Alternative to top/htop"
  homepage "https://nicolargo.github.io/glances/"
  url "https://github.com/nicolargo/glances/archive/v2.11.1.tar.gz"
  sha256 "446a0ee6e13c0c7ceb4bc0d4868add8a02d5e3ff866de8e880bdb33dce6ab3fc"

  bottle do
    cellar :any_skip_relocation
    sha256 "ff4cdbbf531f93187e9b32047ce0ce33b9fe25d3d689bd475303b3ce5a0634c5" => :high_sierra
    sha256 "bfdfdacd387c866e575bc05febd92e131097856b54e3d24f4db84450ddab2508" => :sierra
    sha256 "03cb45f3f3333af6789292890b1a2ea23825a3a77f02f3ebf735c90708818166" => :el_capitan
  end

  depends_on "python" if MacOS.version <= :snow_leopard

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/e2/e1/600326635f97fee89bf8426fef14c5c29f4849c79f68fd79f433d8c1bd96/psutil-5.4.3.tar.gz"
    sha256 "e2467e9312c2fa191687b89ff4bc2ad8843be4af6fb4dc95a7cc5f7d7a327b18"
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
