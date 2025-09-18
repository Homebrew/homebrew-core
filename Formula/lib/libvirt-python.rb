class LibvirtPython < Formula
  desc "Libvirt virtualization API python binding"
  homepage "https://www.libvirt.org/"
  url "https://download.libvirt.org/python/libvirt-python-11.7.0.tar.gz"
  sha256 "f65f80fe7dabb47c2ea887bec5f62509b756282acac4fa958ab74706c0b76c11"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.libvirt.org/python/"
    regex(/href=.*?libvirt-python[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5e1be7e55bae99dc4a93102836e0ce7af80eac3b8bf5370d9def605869fbf645"
    sha256 cellar: :any,                 arm64_sequoia: "e9a1ca2a0a5671bcf9c68d3f4bf5b82495737d24222128ddc04907ca141a0218"
    sha256 cellar: :any,                 arm64_sonoma:  "9076512a8be4fe00e08d0ebfc46eb864d746103bc88a2733edbdb1c98a4cf18f"
    sha256 cellar: :any,                 arm64_ventura: "e55ff103b440772cc22e99382f2a4ac08f0c60a5631ca4216c9327d1041e9b03"
    sha256 cellar: :any,                 sonoma:        "2185011585275d853441e82050874cddd7946f18bb89a3a9f3b37339952a89f0"
    sha256 cellar: :any,                 ventura:       "d3c3f950df8ef835f98e8f324f091278e8a1d3e0379761f02c8e6c77675fdf08"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7d5d96934c622a93861bf6851d0110618d10521bd346a697aeca12fe6bff354"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a266686bd1701e5015f1398655a8b7cb917be9df7ca11406013845e7e077fc99"
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
