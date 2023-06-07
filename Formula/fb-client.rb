class FbClient < Formula
  include Language::Python::Shebang

  desc "Shell-script client for https://paste.xinu.at"
  homepage "https://paste.xinu.at"
  url "https://paste.xinu.at/data/client/fb-2.3.0.tar.gz"
  sha256 "1164eca06eeacb4210d462c4baf1c4004272a6197d873d61166e7793539d1983"
  license "GPL-3.0-only"
  head "https://git.server-speed.net/users/flo/fb", using: :git, branch: "master"

  livecheck do
    url :homepage
    regex(%r{Latest release:.*?href=.*?/fb[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "d46a63ecf65fd97065166fcab2f4386d4c15ae430a49570d645d5744ef594846"
    sha256 cellar: :any,                 arm64_monterey: "4dadf3cfa163f2a583c73c4fa73084d36962566876994c1363d7d779a9654238"
    sha256 cellar: :any,                 arm64_big_sur:  "717e43653007dd176bd23a11099b809d1244d7637aeb1847bfba05bfcfbc78a3"
    sha256 cellar: :any,                 ventura:        "2b862bdfdce5f2a7b6c167fc96c905b951fc1335669d8b297fdc873449cd7703"
    sha256 cellar: :any,                 monterey:       "6bdf26e1eefe758a492a24c686986513cf79e6db8f3ce36c2116b915b7e3657b"
    sha256 cellar: :any,                 big_sur:        "c0904d61b7d29333c7d2c9d5736c3562506a5500400bf336668b5573864d8b3e"
    sha256 cellar: :any,                 catalina:       "8489f0e39c1ccb91dd6bb54ecddc2c124b3f943587d08e4616d2342a48f3662c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00077814d4fef6e1a34653443474be95bdd395d86a1b72a9acc492c6a924ac6e"
  end

  depends_on "pkg-config" => :build
  depends_on "curl"
  depends_on "python@3.11"

  conflicts_with "spotbugs", because: "both install a `fb` binary"

  resource "pycurl" do
    url "https://files.pythonhosted.org/packages/09/ca/0b6da1d0f391acb8991ac6fdf8823ed9cf4c19680d4f378ab1727f90bd5c/pycurl-7.45.1.tar.gz"
    sha256 "a863ad18ff478f5545924057887cdae422e1b2746e41674615f687498ea5b88a"
  end

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/b0/25/7998cd2dec731acbd438fbf91bc619603fc5188de0a9a17699a781840452/pyxdg-0.28.tar.gz"
    sha256 "3267bb3074e934df202af2ee0868575484108581e6f3cb006af1da35395e88b4"
  end

  def install
    # avoid pycurl error about compile-time and link-time curl version mismatch
    ENV.delete "SDKROOT"

    python3 = "python3.11"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor"/Language::Python.site_packages(python3)

    # avoid error about libcurl link-time and compile-time ssl backend mismatch
    resource("pycurl").stage do
      system python3, *Language::Python.setup_install_args(libexec/"vendor", python3),
                      "--curl-config=#{Formula["curl"].opt_bin}/curl-config",
                      "--install-data=#{prefix}"
    end

    resource("pyxdg").stage do
      system python3, *Language::Python.setup_install_args(libexec/"vendor", python3),
                      "--install-data=#{prefix}"
    end

    rewrite_shebang detected_python_shebang, "fb"

    system "make", "PREFIX=#{prefix}", "install"
    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
  end

  test do
    system bin/"fb", "-h"
  end
end
