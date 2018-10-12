class Glances < Formula
  desc "Alternative to top/htop"
  homepage "https://nicolargo.github.io/glances/"
  url "https://github.com/nicolargo/glances/archive/v3.0.2.tar.gz"
  sha256 "76a793a8e0fbdce11ad7fb35000695fdb70750f937db41f820881692d5b0a29c"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "11d86d403e42adfb03e86ee8ad4ea526590309e6f685f699ee6382c292dbdf48" => :mojave
    sha256 "b8b2b0c5ed5697b37b7891405fdd4af2cf04aa14dafb284620d846fe805dc564" => :high_sierra
    sha256 "cb288ba5bcf489c4e2eac0e26a67ac2d7546f13b4e245eb032961df9f66e5b2c" => :sierra
  end

  depends_on "python"

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/7d/9a/1e93d41708f8ed2b564395edfa3389f0fd6d567597401c2e5e2775118d8b/psutil-5.4.7.tar.gz"
    sha256 "5b6322b167a5ba0c5463b4d30dfd379cd4ce245a1162ebf8fc7ab5c5ffae4f3b"
  end

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"
    resource("psutil").stage do
      system "python3", *Language::Python.setup_install_args(libexec/"vendor")
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)

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
