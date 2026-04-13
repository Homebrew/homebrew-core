class LibvirtPython < Formula
  desc "Libvirt virtualization API python binding"
  homepage "https://www.libvirt.org/"
  url "https://download.libvirt.org/python/libvirt_python-12.2.0.tar.gz"
  sha256 "742147988bba7d400f6892beeeb7e0a27758f10ff65421b569b7b4b6a2572e44"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.libvirt.org/python/"
    regex(/href=.*?libvirt[_-]python[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8daf700010b02ec2fb9adf96892ee12bcd83dc8f233c3aa1c670a5c8d7640bda"
    sha256 cellar: :any,                 arm64_sequoia: "01d4a0454fb1ef0bf544b91cff83cb21e3508ea4f102bd48a119a6d932f07f84"
    sha256 cellar: :any,                 arm64_sonoma:  "1b9b8d17b4039f9c6233bc19af7a345ef909c14f00c18fa9da395f7c894ee885"
    sha256 cellar: :any,                 sonoma:        "1967cba9a8103f6bd1297dda3c3c70ba3aea49fe08573c9e712373c321e753e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8ce28cc823f6bd41f07c444c620b0dc0d2d6eb318c0dabaee94239fda1b8013"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1abb85c24a65316ba2c05deb46f8be16f30fa7e6c4ca657a691d568f2a61b11"
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
