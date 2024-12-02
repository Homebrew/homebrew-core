class LibvirtPython < Formula
  desc "Libvirt virtualization API python binding"
  homepage "https://www.libvirt.org/"
  url "https://download.libvirt.org/python/libvirt-python-10.10.0.tar.gz"
  sha256 "8acf6dcfb33a03ed92f9440cb1a0b8d3fc53fb23bba2e76ceedeb8bfb5327557"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.libvirt.org/python/"
    regex(/href=.*?libvirt-python[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "265ee75ccfc21afcbbe6d42833ee4a5e325a0c7d2a28554ed2f2c8153de646cd"
    sha256 cellar: :any,                 arm64_sonoma:  "0280c0041fcc1803c3aaee9aa656ac8083f2ab12a262fdb2d06826ea0f2a2958"
    sha256 cellar: :any,                 arm64_ventura: "b6a289ec7937206de11591a9378d194ba9d355cd3cbf41d72aa978b5eb8a2913"
    sha256 cellar: :any,                 sonoma:        "62dd88bf8a1bb4c88f42c356e6e792aa7455b505e5a4d5d7a30455dd107d29e8"
    sha256 cellar: :any,                 ventura:       "1bcbf2671d75df950d68f23419158d425f6859296780235e01e21b9c8f7386ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "083260eab1d2a1223373b8512eb0cdb79c33b70c9331908a75aa2c382473c4fa"
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
