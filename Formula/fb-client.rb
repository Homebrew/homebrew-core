class FbClient < Formula
  desc "Shell-script client for https://paste.xinu.at"
  homepage "https://paste.xinu.at"
  url "https://paste.xinu.at/data/client/fb-2.0.4.tar.gz"
  sha256 "330c9593afd2b2480162786992d0bfb71be25faf105f3c24c71d514b58ee0cd3"
  revision 1
  head "https://git.server-speed.net/users/flo/fb", :using => :git

  bottle do
    cellar :any
    sha256 "0df2e02a36972a4c16b24243151339b4c8399cfe660daa8a801f0b45d7e5c3a8" => :mojave
    sha256 "d50151d01ab4583c3eacdf81cd03f662d0c535f13925eaeed4208ef2de9fbe6a" => :high_sierra
    sha256 "5fec79ee26b07edfbfd05c8fd459b03bd4751e1256eb206951dafcbcee42dc7a" => :sierra
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
