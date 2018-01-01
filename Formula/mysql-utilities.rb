class MysqlUtilities < Formula
  desc "Tools for maintaining and administering MySQL servers"
  homepage "https://dev.mysql.com/downloads/utilities/"
  url "https://github.com/mysql/mysql-utilities/archive/release-1.6.5.tar.gz"
  sha256 "40b6987064f204fed2286c682c9a6ded8ba4670f7543edd310aab91fee8fbc3b"

  bottle do
    cellar :any_skip_relocation
    sha256 "952e22b82a12919d9fb06d5aba5eb7e214b70c3b5d27e3ab1d219e19e2e01ec9" => :high_sierra
    sha256 "7166858aeafbd28075334ede9d60569a282ccd0a87dcf353cb6b56a40ae987c0" => :sierra
    sha256 "7166858aeafbd28075334ede9d60569a282ccd0a87dcf353cb6b56a40ae987c0" => :el_capitan
    sha256 "7166858aeafbd28075334ede9d60569a282ccd0a87dcf353cb6b56a40ae987c0" => :yosemite
  end

  depends_on "python" if MacOS.version <= :snow_leopard

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
