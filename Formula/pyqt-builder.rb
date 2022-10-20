class PyqtBuilder < Formula
  include Language::Python::Virtualenv

  desc "Tool to build PyQt"
  homepage "https://www.riverbankcomputing.com/software/pyqt-builder/intro"
  url "https://files.pythonhosted.org/packages/3e/ed/fa5ffe4a72903747cdd5860a46483795edc0b70562015dde42724e9ce00f/PyQt-builder-1.14.0.tar.gz"
  sha256 "6755931c6d2f8940553e0334d10c933ce5cc18b64425e94fda1accf4ff774f59"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]
  head "https://www.riverbankcomputing.com/hg/PyQt-builder", using: :hg

  bottle do
    sha256 cellar: :any_skip_relocation, all: "428980753b642e14385fe1e5e60ce0a1faf3ef8d1d2b4157f6f9ddebbdcea946"
  end

  depends_on "python@3.10"
  depends_on "sip"

  def python3
    "python3.10"
  end

  def install
    system Formula["python@3.10"].opt_bin/python3, *Language::Python.setup_install_args(prefix, python3)
  end

  test do
    system bin/"pyqt-bundle", "-V"
    system Formula["python@3.10"].opt_bin/python3, "-c", "import pyqtbuild"
  end
end
