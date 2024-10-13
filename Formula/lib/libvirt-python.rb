class LibvirtPython < Formula
  desc "Libvirt virtualization API python binding"
  homepage "https://www.libvirt.org/"
  url "https://download.libvirt.org/python/libvirt-python-10.8.0.tar.gz"
  sha256 "10cddc61c6bc5659c0eaa3e4c71f3d97c95abf327a51c207affb2e5f49f19f60"
  license "LGPL-2.1-or-later"
  revision 1

  livecheck do
    url "https://download.libvirt.org/python/"
    regex(/href=.*?libvirt-python[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "48b21a0fb616ce0ce88d25d154f80413048663203f3f51fa5cee1a896ccb0572"
    sha256 cellar: :any,                 arm64_sonoma:  "55f710ee5e0b87a16bfe5846815d0752f5c8709e7c8f05eb810fc2fbde1c670d"
    sha256 cellar: :any,                 arm64_ventura: "56304a392beb82de4643f9340c12ce8eb5897ea77e70199eb6cb23260c60094d"
    sha256 cellar: :any,                 sonoma:        "0c7e52aeec5da8fd63c41f89f9ae94bb0468968f1c3a0e7f9832ad97e2b83291"
    sha256 cellar: :any,                 ventura:       "8f8a8dd947b66f9f3e8e19d514e9c6d45e12fb367794dadc74348150338da0ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89ae778e521efc4642dc55328e5197dfa65a4ef7668aa677b94a059f02f51b71"
  end

  depends_on "pkg-config" => :build
  depends_on "libvirt"
  depends_on "python@3.13"

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
             # language=Python
             <<~EOS
               import libvirt

               with libvirt.open('test:///default') as conn:
                   if libvirt.virGetLastError() is not None:
                       raise SystemError("Failed to open a test connection")
             EOS
    end
  end
end
