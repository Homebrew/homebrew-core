class MysqlUtilities < Formula
  desc "Tools for maintaining and administering MySQL servers"
  homepage "https://dev.mysql.com/downloads/utilities/"
  url "https://github.com/mysql/mysql-utilities/archive/release-1.6.5.tar.gz"
  sha256 "40b6987064f204fed2286c682c9a6ded8ba4670f7543edd310aab91fee8fbc3b"

  depends_on :python if MacOS.version <= :snow_leopard

  resource "mysql-connector-python" do
    url "https://github.com/mysql/mysql-connector-python/archive/2.2.2.tar.gz"
    sha256 "fe46832fa4007c81c5aff6574f2852f301f105bf1e351d5cc69e012309116fa1"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    resource("mysql-connector-python").stage do
      system "python", "setup.py", "install", "--prefix=" + libexec
    end

    system "python", "setup.py", "install", "--prefix=" + libexec

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/mysqldiff", "--help"
  end
end
