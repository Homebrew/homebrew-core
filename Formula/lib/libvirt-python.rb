class LibvirtPython < Formula
  desc "Libvirt virtualization API python binding"
  homepage "https://www.libvirt.org/"
  url "https://download.libvirt.org/python/libvirt_python-12.3.0.tar.gz"
  sha256 "cc472e54c05a86db26e21358e1e8554bc85fea3cac6fe2b90e60e6a06e496a8d"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.libvirt.org/python/"
    regex(/href=.*?libvirt[_-]python[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c86cd5a04f8e4be668958fd8630e95906f75ff1b802400eb49c309556ccc966c"
    sha256 cellar: :any,                 arm64_sequoia: "37dcc7dc9666c8b7b652751af32aecf7d28eecfea5de66a1731c1374f0a220d4"
    sha256 cellar: :any,                 arm64_sonoma:  "f624d1053d9952e97e0afd60cb73e125f1b5c7d5e56f561993ecca240a23090f"
    sha256 cellar: :any,                 sonoma:        "af5dc9881e66eb3611de34c68efb5d0df0c0d22261ccc04abd28cb4f87a7ab26"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54845f7a2d96cfcc7f9cfe2342481d9b8aa0513cb525380c692c9b65d3c540cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aaeb22eaa27aed209aba6495765b3d7057a0496ed2eea6fbc8d1eac2e59c3243"
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
