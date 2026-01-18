class LibvirtPython < Formula
  desc "Libvirt virtualization API python binding"
  homepage "https://www.libvirt.org/"
  url "https://download.libvirt.org/python/libvirt-python-11.7.0.tar.gz"
  sha256 "f65f80fe7dabb47c2ea887bec5f62509b756282acac4fa958ab74706c0b76c11"
  license "LGPL-2.1-or-later"
  revision 1

  livecheck do
    url "https://download.libvirt.org/python/"
    regex(/href=.*?libvirt-python[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1deb0cb0a2a9dcc861be14d1af45c8186f50da6e41a83937aec77225e5d7b71b"
    sha256 cellar: :any,                 arm64_sequoia: "e8dfbb5929729f2f8a98afd8582bcc8948d536ec7bb978c92b72c03c419e2e7a"
    sha256 cellar: :any,                 arm64_sonoma:  "13ee2840382e5675a9c757b6b54933d8447d2e7bf14375febff2056d74f22012"
    sha256 cellar: :any,                 sonoma:        "bb57ace6bee4b27eb1bbd774f92c02408f73fd955292ac0479218cf3e280e502"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1b7a3eee6393647a63aceef7bfc190813fbc8107ee49ad23c3a0be660a8a88c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "666e0f5e808e640568c99cddbe94bbf5c0793d0c61486edda3413786fd182a6c"
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
