class Glances < Formula
  desc "Alternative to top/htop"
  homepage "https://nicolargo.github.io/glances/"
  url "https://files.pythonhosted.org/packages/2a/93/c2175c56cb4f7c36460058c6f43e733ed85dfa0616c8a2cbfeac528d6d7f/Glances-3.1.7.tar.gz"
  sha256 "bd282e35df3f29dd1f3f6955489eb7b73b56d92059f6939b1e15ac8cd1581b08"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6629143967722b197afdee82768109ab9d7990cbcc3b113e91f6bd6ebc9bad78"
    sha256 cellar: :any_skip_relocation, big_sur:       "b74dec85bcbd28967c92b09c94f68110adf82c7f78ed93cefa21cb2ca15a9fdf"
    sha256 cellar: :any_skip_relocation, catalina:      "95bba3cae362b358c0c7952b0fa4f5dde334fe3bbf3f5ae8260e2634d94c9410"
    sha256 cellar: :any_skip_relocation, mojave:        "6482243be50d7abd7d8a45a9ab51895931efe42cd57065d3fea5356d03c4e037"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44cfc2c7eb67c3b93ae5a1efa0399e77ffbea3e789418937896be7b9fd5b9eea"
  end

  depends_on "python@3.9"

  resource "future" do
    url "https://files.pythonhosted.org/packages/45/0b/38b06fd9b92dc2b68d58b75f900e97884c45bedd2ff83203d933cf5851c9/future-0.18.2.tar.gz"
    sha256 "b1bead90b70cf6ec3f0710ae53a525360fa360d306a86583adc6bf83a4db537d"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/e1/b0/7276de53321c12981717490516b7e612364f2cb372ee8901bd4a66a000d7/psutil-5.8.0.tar.gz"
    sha256 "0c9ccb99ab76025f2f0bbecf341d4656e9c1351db8cc8a03ccd62e318ab4b5c6"
  end

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"
    resources.each do |r|
      r.stage do
        system "python3", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])

    prefix.install libexec/"share"
  end

  test do
    read, write = IO.pipe
    pid = fork do
      exec bin/"glances", "-q", "--export", "csv", "--export-csv-file", "/dev/stdout", out: write
    end
    header = read.gets
    assert_match "timestamp", header
  ensure
    Process.kill("TERM", pid)
  end
end
