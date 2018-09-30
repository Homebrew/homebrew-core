class Glances < Formula
  desc "Alternative to top/htop"
  homepage "https://nicolargo.github.io/glances/"
  url "https://github.com/nicolargo/glances/archive/v3.0.2.tar.gz"
  sha256 "76a793a8e0fbdce11ad7fb35000695fdb70750f937db41f820881692d5b0a29c"

  bottle do
    cellar :any_skip_relocation
    sha256 "9d5a054a7712b632f9430cd0f8d2f0474fd299c6b43b72f2046bb3dd4f1748fa" => :mojave
    sha256 "e5691fd25f0b6e6bfc7c4a43ee9b31423ea42ecf79eef51b4b8864566a6b7994" => :high_sierra
    sha256 "3737a153762ad7b9b36d146fbfcb8c2ad024175867a6b79906b6215485dd5870" => :sierra
    sha256 "6f7cb326667e1854eb8f9e3ed9774b7292bb291a4f0378cac01f884075bc671c" => :el_capitan
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
        exec bin/"glances", "-q", "--export", "csv", "--export-csv", "/dev/stdout", :out => write
      end
      header = read.gets
      assert_match "timestamp", header
    ensure
      Process.kill("TERM", pid)
    end
  end
end
