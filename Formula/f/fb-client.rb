class FbClient < Formula
  include Language::Python::Shebang

  desc "Shell-script client for https://paste.xinu.at"
  homepage "https://paste.xinu.at"
  url "https://paste.xinu.at/data/client/fb-2.3.0.tar.gz"
  sha256 "1164eca06eeacb4210d462c4baf1c4004272a6197d873d61166e7793539d1983"
  license "GPL-3.0-only"
  revision 1
  head "https://git.server-speed.net/users/flo/fb", using: :git, branch: "master"

  livecheck do
    url :homepage
    regex(%r{Latest release:.*?href=.*?/fb[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "649b97ec44849d197d96bd28e094bc69ec21e045263a29ab937fe55600d2544f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2cd645e0b6c1a1e57ecf611b1271f3907b53d7eb94e76e35e3f1160741c1694a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "05e1f964c6fb35777e0c133a165f0849e784ee840b35b89bdb1f2abc4728b892"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e411d7e27f3ef04aa001b2eeab1f8def46edf7352cc36572664df6c28c50834a"
    sha256 cellar: :any_skip_relocation, sonoma:         "05b3e931a857449985db79ed468c8ee7869b40b11dbcf5d36112f80d0ef6a4af"
    sha256 cellar: :any_skip_relocation, ventura:        "4c8f0b1f62e2a87e96deb9dfb48afdc6558e44ea472ec25be0a00c0f62941a76"
    sha256 cellar: :any_skip_relocation, monterey:       "a2a27e170becfd88043a68277fc103802298d9b9d421cdfd9ef549faf30bd82f"
    sha256 cellar: :any_skip_relocation, big_sur:        "b7830abf812f263afd129397682feec2d8a103dfba08eff24c53da18d7a97f7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d382d9e24b1a0a00512191c171fc11e7af8b9d48e3aee43e289bfd313bfe193"
  end

  depends_on "pkg-config" => :build
  depends_on "python-pycurl"
  depends_on "python@3.11"

  conflicts_with "spotbugs", because: "both install a `fb` binary"

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/b0/25/7998cd2dec731acbd438fbf91bc619603fc5188de0a9a17699a781840452/pyxdg-0.28.tar.gz"
    sha256 "3267bb3074e934df202af2ee0868575484108581e6f3cb006af1da35395e88b4"
  end

  def install
    python3 = "python3.11"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor"/Language::Python.site_packages(python3)
    resources.each do |r|
      r.stage do
        system python3, "-m", "pip", "install", *std_pip_args(prefix: libexec/"vendor"), "."
      end
    end

    rewrite_shebang detected_python_shebang, "fb"

    system "make", "PREFIX=#{prefix}", "install"
    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
  end

  test do
    system bin/"fb", "-h"
  end
end
