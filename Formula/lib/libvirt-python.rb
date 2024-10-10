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
    sha256 cellar: :any,                 arm64_sequoia: "d1e5e493a836179896350ef3ea44a6626aba24fef6564064a665858c57fc9df3"
    sha256 cellar: :any,                 arm64_sonoma:  "ba5fcf6e3732415bdb2dd9fe8598f32bc869c949e9010710da0dd422a5c66843"
    sha256 cellar: :any,                 arm64_ventura: "355bcdfa84c218bf0965b20437fe641f087feac497a842e815832245ef768cb9"
    sha256 cellar: :any,                 sonoma:        "a0d32c7b2eb10df36ae16d2fb97544bc6d6ea0173f09de286982e5edf4c005b6"
    sha256 cellar: :any,                 ventura:       "193970d5cc76fad094030ba042c22f6e78c9f17d2c2213019e9ea53fa5254467"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed5f424499195fff0e6471ba50cbf2317a84a5239446e9ff6b2b93ad42dffa8a"
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
