class LibvirtPython < Formula
  desc "Libvirt virtualization API python binding"
  homepage "https://www.libvirt.org/"
  url "https://download.libvirt.org/python/libvirt-python-10.4.0.tar.gz"
  sha256 "a20273a3374fcacb45b5ac4fd135e2c40460bb4a3a290d26c4aa8d0eaf1225b5"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.libvirt.org/python/"
    regex(/href=.*?libvirt-python[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6358b9bb1a1ae12938cc9d002eba3a47384ab152124f1cefb70f90bdbb282ad2"
    sha256 cellar: :any,                 arm64_ventura:  "cb2e1b01519d70641b0445ae81872621b25708b17c0279e51e9f777df3ecb856"
    sha256 cellar: :any,                 arm64_monterey: "879a1989fb88480ad7bb7198aca09dd6bf7bc162e153013b5f010c7a2a28490c"
    sha256 cellar: :any,                 sonoma:         "0af3b557f2d25238078204238af97e76648b583b224f9d168f479b6cedc64069"
    sha256 cellar: :any,                 ventura:        "24b5a5ad02dbb81724fd29cc175c8474d7a33cfedd2934e0ce5a5b12120d9f70"
    sha256 cellar: :any,                 monterey:       "6dd0f44652828812979a3cfb3e39068765900fa6491c76d5a91c98f18f986223"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5bc27311f35d9fcb3c23c5a3e6d92911db97fd00c60a932bbd44008e1dfe7a2c"
  end

  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
  depends_on "libvirt"
  depends_on "python@3.12"

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/^python@\d\.\d+$/) }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python|
      system python, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    system "python3.12", "-c",
           # language=Python
           <<~EOS
             import libvirt

             with libvirt.open('test:///default') as conn:
                 if libvirt.virGetLastError() is not None:
                     raise SystemError("Failed to open a test connection")
           EOS
  end
end
