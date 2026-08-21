class LibvirtPython < Formula
  desc "Libvirt virtualization API python binding"
  homepage "https://www.libvirt.org/"
  url "https://download.libvirt.org/python/libvirt_python-12.6.0.tar.gz"
  sha256 "f390abff81d4afd6c33157ade82912863b87de9c35172e9b0c9f0dfcdc09b139"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.libvirt.org/python/"
    regex(/href=.*?libvirt[_-]python[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "25a3af32debde7f0f8172fec13277aabdd1e8544a5f21db62724814a87ef6a72"
    sha256 cellar: :any, arm64_sequoia: "472065e1fe73003c480af9bf9254ecd936fd4a8931af55c36103faac1db335ad"
    sha256 cellar: :any, arm64_sonoma:  "7243bd989b503d1116bb6ffb0d22c241c7d1c5b2346a12a76d00c53ed870d0b6"
    sha256 cellar: :any, sonoma:        "f9f431688569084cfbdaf5d3023f925bc1090d388bc5db2222a22eb022fa1a61"
    sha256 cellar: :any, arm64_linux:   "e3ccb46646ade51dba70f6cf0584fc7ce6d080cbbf8b7d05fa691d4b6d7277fe"
    sha256 cellar: :any, x86_64_linux:  "f707b9e8ccb9f3ec911cd70b251ed20a04c8a59cc817578b015b8b57f6e3fd48"
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
