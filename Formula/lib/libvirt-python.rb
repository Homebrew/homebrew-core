class LibvirtPython < Formula
  desc "Libvirt virtualization API python binding"
  homepage "https://www.libvirt.org/"
  url "https://download.libvirt.org/python/libvirt_python-12.0.0.tar.gz"
  sha256 "7b4de7d2dde2bc380cf4e108d1eeb8aad50beb3ae351ab9265a7fedc587742bc"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.libvirt.org/python/"
    regex(/href=.*?libvirt[_-]python[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f414cfa15ca808ef01a40d3effec900bc597b210577760838efc168bb705f8b6"
    sha256 cellar: :any,                 arm64_sequoia: "979fb783af4eac003e83974e3d2156fe453e786b05e45cb9760e64b1926021fe"
    sha256 cellar: :any,                 arm64_sonoma:  "2d435ef923c48bbb1caa350f85216f20ce7c29ab37ca3caa787a00f1da8880b2"
    sha256 cellar: :any,                 sonoma:        "17de2033b542a2cd04e0d5897dfa6bfd8b93d159538f466e72c4cfc65c8bae0a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cdea3bced181acc35e4277250a0bdebd0d7f9bfb341e73256b6d39b6068db492"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48db6a4c220d19b56f1b1495bfffec2d4c6830ca2d6f5844cbc5e00d508721bc"
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
