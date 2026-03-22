class LibvirtPython < Formula
  desc "Libvirt virtualization API python binding"
  homepage "https://www.libvirt.org/"
  url "https://download.libvirt.org/python/libvirt_python-12.1.0.tar.gz"
  sha256 "2cc02c0b91a9abd140185feab46b33281091d4deffbc1bbfdb68ce682359f2b0"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.libvirt.org/python/"
    regex(/href=.*?libvirt[_-]python[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "df82545cb92407cbb6bfb96f63fa7c1fac2a4b089369f4b90e674e26370a6e46"
    sha256 cellar: :any,                 arm64_sequoia: "d3fe564eac106528dfb2092daf1ad94e2b31cc0d0a9f98a016437f0de74ed05b"
    sha256 cellar: :any,                 arm64_sonoma:  "72d49e56c78cffb1cbbda76cd62eceb6e159432478d89b81897bb8a8899aad2d"
    sha256 cellar: :any,                 sonoma:        "234a4a88a9037a5321e3e901c0a0d3fd84a93cd234ab81c2e72b2cd428ebfc50"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f1ddd535cefc97683075b6e2d2660a6829707b850538c26f31eb09cd1d84136"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16b1fc2cf62ef1b1262e16d8f79c8d4702825637a98755a66da97a31c7aac697"
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
