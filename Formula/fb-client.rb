class FbClient < Formula
  desc "Shell-script client for https://paste.xinu.at"
  homepage "https://paste.xinu.at"
  url "https://paste.xinu.at/data/client/fb-2.0.4.tar.gz"
  sha256 "330c9593afd2b2480162786992d0bfb71be25faf105f3c24c71d514b58ee0cd3"
  revision 1
  head "https://git.server-speed.net/users/flo/fb", :using => :git

  bottle do
    cellar :any
    rebuild 1
    sha256 "cdcc8da860e21b55408369556cd2d74d0b85e0ce3b0486ef3efe54d674a4832a" => :catalina
    sha256 "1e2a04de1b67cb39442f8ce50e852ca02b617d93697f3f87414ab5448a529bc4" => :mojave
    sha256 "294e9014f93b9dfd3e31e2eafeec205bb92db28c2d6e2b59b3b113e240e8b277" => :high_sierra
    sha256 "9fa4abfeef74367bdd1305181126bde6009b1cef6c5b6acdc8c878433270b920" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "curl-openssl"
  depends_on "python"

  conflicts_with "findbugs", :because => "findbugs and fb-client both install a `fb` binary"

  resource "pycurl" do
    url "https://files.pythonhosted.org/packages/e8/e4/0dbb8735407189f00b33d84122b9be52c790c7c3b25286826f4e1bdb7bde/pycurl-7.43.0.2.tar.gz"
    sha256 "0f0cdfc7a92d4f2a5c44226162434e34f7d6967d3af416a6f1448649c09a25a4"
  end

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/47/6e/311d5f22e2b76381719b5d0c6e9dc39cd33999adae67db71d7279a6d70f4/pyxdg-0.26.tar.gz"
    sha256 "fe2928d3f532ed32b39c32a482b54136fe766d19936afc96c8f00645f9da1a06"
  end

  def install
    # avoid pycurl error about compile-time and link-time curl version mismatch
    ENV.delete "SDKROOT"

    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"

    # avoid error about libcurl link-time and compile-time ssl backend mismatch
    resource("pycurl").stage do
      system "python3", *Language::Python.setup_install_args(libexec/"vendor"),
                        "--curl-config=#{Formula["curl-openssl"].opt_bin}/curl-config"
    end

    resource("pyxdg").stage do
      system "python3", *Language::Python.setup_install_args(libexec/"vendor")
    end

    inreplace "fb", "#!/usr/bin/env python", "#!/usr/bin/env python3"

    system "make", "PREFIX=#{prefix}", "install"
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system bin/"fb", "-h"
  end
end
