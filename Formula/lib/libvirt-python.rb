class LibvirtPython < Formula
  desc "Libvirt virtualization API python binding"
  homepage "https://www.libvirt.org/"
  url "https://download.libvirt.org/python/libvirt_python-12.8.0.tar.gz"
  sha256 "ab24a102ebf99b913ddc3459031aa71a48b0b1cdbb0f423b4ea278052791ac8a"
  license "LGPL-2.1-or-later"
  revision 1

  livecheck do
    url "https://download.libvirt.org/python/"
    regex(/href=.*?libvirt[_-]python[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a9096d60d1e72dabccce57a96accca52082cbdb5c7699539f5a8a1c67f1a8111"
    sha256 cellar: :any, arm64_tahoe:       "295cbb53a26506c755b48fab03cbc5c2cd16f4b8a9a3f6cd529c1112f8452385"
    sha256 cellar: :any, arm64_sequoia:     "0d75dcdd633b8f1830bc0c91b8fd730418c8c533df0bea80d9aa4939b110bc30"
    sha256 cellar: :any, arm64_linux:       "ca9d669e30045d09e233b31ae4c58c99063504812c613472c53579cbe3f48e0c"
    sha256 cellar: :any, x86_64_linux:      "3d5981c38ebee07809fdaf5a12fd4d8ed58cdc5512515a08150c7e27a9ee0619"
  end

  depends_on "pkgconf" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.14" => [:build, :test]
  depends_on "python@3.15" => [:build, :test]
  depends_on "libvirt"

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
    (testpath/"test.py").write <<~PYTHON
      import libvirt

      with libvirt.open('test:///default') as conn:
        if libvirt.virGetLastError() is not None:
          raise SystemError("Failed to open a test connection")
    PYTHON

    pythons.each do |python|
      system python, "test.py"
    end
  end
end
