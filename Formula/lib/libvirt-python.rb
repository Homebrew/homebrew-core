class LibvirtPython < Formula
  desc "Libvirt virtualization API python binding"
  homepage "https://www.libvirt.org/"
  url "https://download.libvirt.org/python/libvirt_python-12.5.0.tar.gz"
  sha256 "25ea2261e0d6cab9d004b700911d88b57911b14528ed04b3487a617ec2b4cda9"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.libvirt.org/python/"
    regex(/href=.*?libvirt[_-]python[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c8685eb4602e47cf1056e5f2ba579e77b03e1ea652456e63b3f6cd0e7e0e880d"
    sha256 cellar: :any, arm64_sequoia: "8b4c0e029002d5b5feef826de33e7f4fee50c3dcf017fce4791dd598ea461b5f"
    sha256 cellar: :any, arm64_sonoma:  "8a3c65eeca8155b1a1ad898ef93802ecdaaef1266b131c4148b91670c25548d6"
    sha256 cellar: :any, sonoma:        "d7c3f9382912e42f5e8ec1658685c173ca041c2f85f50de35c5e1d74b54318c6"
    sha256 cellar: :any, arm64_linux:   "06f709efa71f627b2d995a6e3a8f19fc4e4ae4013e065c8866a5d1c829905acc"
    sha256 cellar: :any, x86_64_linux:  "d288d05a94177c19518f281c9a4e269e26a67eefc3974a2b774b1c66a414a99c"
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
