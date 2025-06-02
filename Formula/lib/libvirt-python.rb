class LibvirtPython < Formula
  desc "Libvirt virtualization API python binding"
  homepage "https://www.libvirt.org/"
  url "https://download.libvirt.org/python/libvirt-python-11.3.0.tar.gz"
  sha256 "4cd31e625e8fefbbe168faedb38cb7fa2da3fa7394326eed29dc46e7ca511979"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.libvirt.org/python/"
    regex(/href=.*?libvirt-python[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4a9e95b87f0b37422b50ff3f409fc34292e8bab6c65682ab98a33c1ace46a6b2"
    sha256 cellar: :any,                 arm64_sonoma:  "79b531d7a08b74ab2941c6b31be5750ba0741a288e925e558ff490a38b65a8d2"
    sha256 cellar: :any,                 arm64_ventura: "92b57743196e81f9b57833038b6762d67779431a734acb7cf428468bc3c37443"
    sha256 cellar: :any,                 sonoma:        "3c44d8f88bb438fcac11f1d0bef8e979290c803e004b1d08c1ac274882e985d9"
    sha256 cellar: :any,                 ventura:       "5e12aa079214f02b71865823fbf04b629067abede419722d499bd7feee660456"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ae1c68fe55d1f5dbe51dbe510af77f15140a4eeb03ad1f40905b73bc5007aeb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea1b1e019096bc81f21ca7e75a3200fd38e1c189be7b20820faedaa29c512620"
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
