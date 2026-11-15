class LibvirtPython < Formula
  desc "Libvirt virtualization API python binding"
  homepage "https://www.libvirt.org/"
  url "https://download.libvirt.org/python/libvirt_python-12.9.0.tar.gz"
  sha256 "598b85cd1f5e94b97684b725cd45a65f6ab734c6edaa61d4aec98721f30e9401"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  livecheck do
    url "https://download.libvirt.org/python/"
    regex(/href=.*?libvirt[_-]python[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "87ba5e625d38aa12810e6f0c3926104129e5e75c5d60c31de3a0efed959ce01d"
    sha256 cellar: :any, arm64_tahoe:       "aa5358083a0d8b4b756d4ffa19eddb6f044c446c226d406632b91348243f30d1"
    sha256 cellar: :any, arm64_sequoia:     "6de51deb46723dc43f314d0a404d197cadccf14b713e92713af3e94f04d98024"
    sha256 cellar: :any, arm64_linux:       "01bb81197894d1be4d5ef1ce3f8f614528bdffb7c8c2de1aefe088a916b49a37"
    sha256 cellar: :any, x86_64_linux:      "ccfbc32b3a62bd2b2684b08a0a75e02c7032e55264bddfa89ab21216ba95a34b"
  end

  depends_on "pkgconf" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.14" => [:build, :test]
  depends_on "python@3.15" => [:build, :test]
  depends_on "libvirt"

  deny_network_access!

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
