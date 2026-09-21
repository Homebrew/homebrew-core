class LibvirtPython < Formula
  desc "Libvirt virtualization API python binding"
  homepage "https://www.libvirt.org/"
  url "https://download.libvirt.org/python/libvirt_python-12.7.0.tar.gz"
  sha256 "03a6800a3cc7657267e2516f579ce95c93d6351182caf03f92a49556685bf8bf"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.libvirt.org/python/"
    regex(/href=.*?libvirt[_-]python[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d5c001e75211b2473934e6579ef7a32250050b95b9871285c2f32342475b64d4"
    sha256 cellar: :any, arm64_tahoe:       "9ac69f031a374ef3eaffe7e601c1b238e4bd93671a667d15160f5f6bcd168125"
    sha256 cellar: :any, arm64_sequoia:     "1b0f537518716e657ecd9d01770f20743bc76058d4d9fb3830536970ca6fe6f0"
    sha256 cellar: :any, arm64_sonoma:      "42a99c27f3d2c4bf46412a8ec8ed4574dd6011022174f322fbe862e7ec9a049a"
    sha256 cellar: :any, arm64_linux:       "ecdc8eca1aa97220a98ac92c0b7384ee2510e762f2f1748f602b2c9608532e77"
    sha256 cellar: :any, x86_64_linux:      "80c4ecfddf32d56d644696a6118ca40c96e109594452ee110dde19235161d035"
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
