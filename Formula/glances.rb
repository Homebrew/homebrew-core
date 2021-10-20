class Glances < Formula
  desc "Alternative to top/htop"
  homepage "https://nicolargo.github.io/glances/"
  url "https://files.pythonhosted.org/packages/2a/93/c2175c56cb4f7c36460058c6f43e733ed85dfa0616c8a2cbfeac528d6d7f/Glances-3.1.7.tar.gz"
  sha256 "bd282e35df3f29dd1f3f6955489eb7b73b56d92059f6939b1e15ac8cd1581b08"
  license "LGPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a14a59f4732ccc11865a74bb059d06e12d8f02e442eac8f5464df7d87187962b"
    sha256 cellar: :any_skip_relocation, big_sur:       "bf357cfaa047f96c4cccd9671dc1c339af5022ae5d30fab2f5e31a267bddd2f8"
    sha256 cellar: :any_skip_relocation, catalina:      "6e77821dd7393ffbe14484ad40fcaf02446c3f283d8a07d0edfcc5e42bc1e0ad"
    sha256 cellar: :any_skip_relocation, mojave:        "e785dca2522e2e25b2d70e7da24b1409df1e8aa6ac6c0203bd49405b52722a53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d320ac2305adbd1cb83a6503928fe26a58dd1e07951703cc34a65b5157ecbe6f"
  end

  depends_on "python@3.10"

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
