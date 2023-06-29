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
    sha256 cellar: :any,                 arm64_ventura:  "537eda37cb3bd26c4873ce83bdb9dbc8c41caeb392d2c0ade6507e1c44695c76"
    sha256 cellar: :any,                 arm64_monterey: "320fa43c7cabdf9f3014db7ffc0145ecf187b5e4bf915202ba74e0298eaf6590"
    sha256 cellar: :any,                 arm64_big_sur:  "de361b1fbff71a9042ae403b5e4305ef85d09b4f4f546e3ab1184954150c3f45"
    sha256 cellar: :any,                 ventura:        "7634d244c93543f5ab6a05e4f730ba67ee79917695b324e9d4b7bfa77819fcb4"
    sha256 cellar: :any,                 monterey:       "b2e427fce34347a147339ca1475d88c276c5200ce3a20592ba84abe2d56e9f64"
    sha256 cellar: :any,                 big_sur:        "3d4d6131f828be8e190b5c41a07fb43fd136c638198575f73fa42c4fd4782772"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae2fb8b3cbe02544d90f47ec3cfdccfe6e524df67285a9969ff7356f61ae85a6"
  end

  depends_on "pkg-config" => :build
  depends_on "curl"
  depends_on "openssl@3"
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
