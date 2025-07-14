class LibvirtPython < Formula
  desc "Libvirt virtualization API python binding"
  homepage "https://www.libvirt.org/"
  url "https://download.libvirt.org/python/libvirt-python-11.5.0.tar.gz"
  sha256 "69aad89ec689526835bf7d2d224badafe52a2def0d719676166755a8eab7ac23"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.libvirt.org/python/"
    regex(/href=.*?libvirt-python[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7221610e7441ce6117a016a46f794a3c903a01666841debcf487b46ae19fc4c2"
    sha256 cellar: :any,                 arm64_sonoma:  "af0cba8e1296774e3f1aae147a1aab56e9493d648f1337ccfa67399a1a16a0f4"
    sha256 cellar: :any,                 arm64_ventura: "73db18836027dac362fd47b9e28e78ef123368524cc138d54f1faef8db188866"
    sha256 cellar: :any,                 sonoma:        "f23f0f3ce9034416d534af3cca0fda7795906258a59ddc5f65abcf9e254714f1"
    sha256 cellar: :any,                 ventura:       "4903f34c38b882da7fb274f076a951502d21a966e4a3a11e02ee72b68a8c99e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "afb24a03b0cca8f081caee384e721cf5b61e86d6de0c34d0225c2e18d85d4681"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c199985d3b07b79f6c46cbcf222e85677d7555893d14c8aefc2e53186e193876"
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
