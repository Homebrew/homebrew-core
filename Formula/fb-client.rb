class FbClient < Formula
  desc "Shell-script client for https://paste.xinu.at"
  homepage "https://paste.xinu.at"
  url "https://paste.xinu.at/data/client/fb-2.1.1.tar.gz"
  sha256 "8fbcffc853b298a8497ab0f66b254c0c9ae4cbd31ab9889912a44a8c5c7cef0e"
  revision 2
  head "https://git.server-speed.net/users/flo/fb", using: :git

  livecheck do
    url :homepage
    regex(%r{Latest release:.*?href=.*?/fb[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    cellar :any
    sha256 "cac3dc19fcf97fda03904b7e1e72fe349eb639dd0a51f837880e3cddad7da1b8" => :big_sur
    sha256 "82e67636b175bcc810c7789d2707e885d30d89a4a65e08c0719278242a6fe8ee" => :catalina
    sha256 "a7d6b0bc96223ea4beb09d0552a7af27c73d52f5cef8ea2c4d60eb8d8d0c5bcc" => :mojave
    sha256 "1461589a04844a009842a6754b028e023129d995206ba31ad98089cee10d5018" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "curl"
  depends_on "python@3.9"

  conflicts_with "findbugs", because: "findbugs and fb-client both install a `fb` binary"

  resource "pycurl" do
    url "https://files.pythonhosted.org/packages/50/1a/35b1d8b8e4e23a234f1b17a8a40299fd550940b16866c9a1f2d47a04b969/pycurl-7.43.0.6.tar.gz"
    sha256 "8301518689daefa53726b59ded6b48f33751c383cf987b0ccfbbc4ed40281325"
  end

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/47/6e/311d5f22e2b76381719b5d0c6e9dc39cd33999adae67db71d7279a6d70f4/pyxdg-0.26.tar.gz"
    sha256 "fe2928d3f532ed32b39c32a482b54136fe766d19936afc96c8f00645f9da1a06"
  end

  def install
    # avoid pycurl error about compile-time and link-time curl version mismatch
    ENV.delete "SDKROOT"

    xy = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"

    # avoid error about libcurl link-time and compile-time ssl backend mismatch
    resource("pycurl").stage do
      system Formula["python@3.9"].opt_bin/"python3",
             *Language::Python.setup_install_args(libexec/"vendor"),
             "--curl-config=#{Formula["curl"].opt_bin}/curl-config"
    end

    resource("pyxdg").stage do
      system Formula["python@3.9"].opt_bin/"python3",
             *Language::Python.setup_install_args(libexec/"vendor")
    end

    inreplace "fb", "#!/usr/bin/env python", "#!#{Formula["python@3.9"].opt_bin}/python3"

    system "make", "PREFIX=#{prefix}", "install"
    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
  end

  test do
    system bin/"fb", "-h"
  end
end
