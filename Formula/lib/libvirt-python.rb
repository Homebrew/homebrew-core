class LibvirtPython < Formula
  desc "Libvirt virtualization API python binding"
  homepage "https://www.libvirt.org/"
  url "https://download.libvirt.org/python/libvirt-python-11.2.0.tar.gz"
  sha256 "bb5f245f0e01579b0b48e8657f0488f440e609c6b6c3c7c7e7c4ae4e61d3c346"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.libvirt.org/python/"
    regex(/href=.*?libvirt-python[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "aa6c2985f81c4768d56b3a973b1e7c870b35dc8f66ade1b65d794f1fd8d82616"
    sha256 cellar: :any,                 arm64_sonoma:  "5f83c3007e5b917678eea79feb1750271c7061361de2280f428a10260e63565a"
    sha256 cellar: :any,                 arm64_ventura: "abd71d9b1f15543d5148b137133c54bf3fea056dfea279a66e5719aae89d2f70"
    sha256 cellar: :any,                 sonoma:        "69782739eace953ab6f676a6c00e731925a812f328195b1ba13d791750c49f5a"
    sha256 cellar: :any,                 ventura:       "ccfaee4e3c92c45b9ddaa365fbf57be07bf2042e6693bd4e700816ed8ed9eca7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7274c6019c62962d6b18aa69cd6a7c27836d5e109fe6058543982f1c264e15c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7cd1cdc14fb01c7b39ff1159201a3bb05e782c4d4d36675f520ce03d208b3695"
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
