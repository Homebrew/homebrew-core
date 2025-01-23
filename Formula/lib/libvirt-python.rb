class LibvirtPython < Formula
  desc "Libvirt virtualization API python binding"
  homepage "https://www.libvirt.org/"
  url "https://download.libvirt.org/python/libvirt-python-11.0.0.tar.gz"
  sha256 "cee825a53c6438c5bc84b4250b35493a8e504d5d8075d3d2069ffaf7090846f8"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.libvirt.org/python/"
    regex(/href=.*?libvirt-python[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "995696e9d6f959e8cb4508cf0d894f6661dc163f1ec2d8f7efe28bfa0cf7e26b"
    sha256 cellar: :any,                 arm64_sonoma:  "4d46dd6ee4055036cc7706186c0e5d009be871ff0c5737f1ab2c5cc50e7b1f4e"
    sha256 cellar: :any,                 arm64_ventura: "26d724127bd63bae989345b3ce9c4d918cd80d216c4e347a8e2cd49c8c83ea8c"
    sha256 cellar: :any,                 sonoma:        "14523ca3bce0f2cf90b678a159606524f10f96a71c1f36ff21367d5782ad174d"
    sha256 cellar: :any,                 ventura:       "1dbb930e5618fb54caf38e0a408772635930680dd58e779bbb151a59b9d6364b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a6aa720d8df55740a0230c8f1211365bb7b030e9111ab0657f14fdfb6b66d5c"
  end

  depends_on "pkgconf" => :build
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
