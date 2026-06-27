class LibvirtPython < Formula
  desc "Libvirt virtualization API python binding"
  homepage "https://www.libvirt.org/"
  url "https://download.libvirt.org/python/libvirt_python-12.4.0.tar.gz"
  sha256 "e24ade7e9b774b56ce3ea6c69ea06b99103391b09c8d9f77a308584b79c9a00d"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.libvirt.org/python/"
    regex(/href=.*?libvirt[_-]python[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "aec0b1b13098fa5ac588b10de6a75a46750aede6c03c38b85187dd4a15338837"
    sha256 cellar: :any, arm64_sequoia: "99bd4d9d41925f2fdccbe585816df4c5d525c25403591e9a0643f2a9948cbbcb"
    sha256 cellar: :any, arm64_sonoma:  "5697af77b379b8601f82561e26415d99aff131b6d18c5eda687f16490a15e1ca"
    sha256 cellar: :any, sonoma:        "abaf140efb799675ab7df87aad42fbb1871434b2613ed5ae066e5f5da5e65974"
    sha256 cellar: :any, arm64_linux:   "274d7047a216b1322f15e8bdf0ee018b09a3c5fde2f1f1ce19b462f8b66b8719"
    sha256 cellar: :any, x86_64_linux:  "8bca1ee1f9c4d034a680faf2ea8735f2e3ebd41ed45d749bad3e5132819d3a72"
  end

  depends_on "pkgconf" => :build
  depends_on "libvirt"
  depends_on "python@3.14"

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/^python@\d\.\d+$/) }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python|
      system python, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
    end
  end

  test do
    pythons.each do |python|
      system python, "-c",
             <<~PYTHON
               import libvirt

               with libvirt.open('test:///default') as conn:
                   if libvirt.virGetLastError() is not None:
                       raise SystemError("Failed to open a test connection")
             PYTHON
    end
  end
end
