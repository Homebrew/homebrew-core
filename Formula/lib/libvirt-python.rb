class LibvirtPython < Formula
  desc "Libvirt virtualization API python binding"
  homepage "https://www.libvirt.org/"
  url "https://download.libvirt.org/python/libvirt-python-10.6.0.tar.gz"
  sha256 "e4259cbd724f784fca9bf22b13e8af1195dead6beee4c6ea08481a66dfdc79e4"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.libvirt.org/python/"
    regex(/href=.*?libvirt-python[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f8513e7db898c86cb7ec5694512662419f1b8f98800b7eda2525af8e95c54623"
    sha256 cellar: :any,                 arm64_ventura:  "818d1122c12b73e19c58b44734319b0abc26dd42613535ec1b855ba21a5fa072"
    sha256 cellar: :any,                 arm64_monterey: "8f237a179ea616b7d9d8b892a65b8ddb0aa79a804a5a86c83713227685a50f36"
    sha256 cellar: :any,                 sonoma:         "c2c378430b2bbdb617c65eeef469eb51b554d58fb9abbf314ddab3d1c7fdbdb4"
    sha256 cellar: :any,                 ventura:        "7bc54bb1ad3fefd533d59b3c429f57d1f3513a0f6de5058b43439a4ccb955668"
    sha256 cellar: :any,                 monterey:       "1538d94d2a76999f83ca5e369375f59e625ed86719311a5912932c5094161cdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c61b02df8926610d82b49b2f4a2608dc2498868a5f4bd9a4a50aeae85ad65117"
  end

  depends_on "pkg-config" => :build
  depends_on "libvirt"
  depends_on "python@3.12"

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
    system "python3.12", "-c",
           # language=Python
           <<~EOS
             import libvirt

             with libvirt.open('test:///default') as conn:
                 if libvirt.virGetLastError() is not None:
                     raise SystemError("Failed to open a test connection")
           EOS
  end
end
