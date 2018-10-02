class Glances < Formula
  desc "Alternative to top/htop"
  homepage "https://nicolargo.github.io/glances/"
  url "https://github.com/nicolargo/glances/archive/v3.0.2.tar.gz"
  sha256 "76a793a8e0fbdce11ad7fb35000695fdb70750f937db41f820881692d5b0a29c"

  bottle do
    cellar :any_skip_relocation
    sha256 "5989b6cf877b94aa5ee4a5bc0e1182822bc2325847b4c9729bcd4293bf08af66" => :mojave
    sha256 "7dea8cd4f0d6d74380e850284a40f7e4f34a13b63157eb30a290ec1b261478f3" => :high_sierra
    sha256 "8a0f4fd7e48069d3fe7c45e3de0ffb91d00715a3d8a95e2de32957461a6a406a" => :sierra
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
