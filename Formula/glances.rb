class Glances < Formula
  desc "Alternative to top/htop"
  homepage "https://nicolargo.github.io/glances/"
  url "https://files.pythonhosted.org/packages/2a/93/c2175c56cb4f7c36460058c6f43e733ed85dfa0616c8a2cbfeac528d6d7f/Glances-3.1.7.tar.gz"
  sha256 "bd282e35df3f29dd1f3f6955489eb7b73b56d92059f6939b1e15ac8cd1581b08"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "93d5581ed75138ec02fce99be6cb458f55824192a77bf01f810676df612a8c18"
    sha256 cellar: :any_skip_relocation, big_sur:       "27690378cfd22dfb6b7ace07409abfb0d0ec1ef452492aad352eee852b005258"
    sha256 cellar: :any_skip_relocation, catalina:      "9b5c8bf188496b2b74ca32b66402cc423dfcd9ce193b9c9c4b3b1bc0246c1275"
    sha256 cellar: :any_skip_relocation, mojave:        "abc3f5bece445731db56508950a3c841631f835c712fe0c8afed8223b73d4387"
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
