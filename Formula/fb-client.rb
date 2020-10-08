class FbClient < Formula
  desc "Shell-script client for https://paste.xinu.at"
  homepage "https://paste.xinu.at"
  url "https://paste.xinu.at/data/client/fb-2.1.0.tar.gz"
  sha256 "4c5eff822244271b9b189a8e279fd87b23b3c3ae02b895b763e3313cdc088353"
  head "https://git.server-speed.net/users/flo/fb", using: :git

  livecheck do
    url :homepage
    regex(%r{Latest release:.*?href=.*?/fb[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    cellar :any
    sha256 "9201e56a1eee16514620d911903281f5594733c83d8b2c765888964ec09b5b0d" => :catalina
    sha256 "0700fc2248570396bef4fdaf8c4f6f546b1d890e53f2060b67c4a80ef5666d27" => :mojave
    sha256 "a351bd6b2ebb88a2f93ef88f3c8623c4fcc4d58996be8a21aecdfbe62b5958ea" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "curl-openssl"
  depends_on "python@3.8"

  conflicts_with "findbugs", because: "findbugs and fb-client both install a `fb` binary"

  resource "pycurl" do
    url "https://files.pythonhosted.org/packages/ef/05/4b773f74f830a90a326b06f9b24e65506302ab049e825a3c0b60b1a6e26a/pycurl-7.43.0.5.tar.gz"
    sha256 "ec7dd291545842295b7b56c12c90ffad2976cc7070c98d7b1517b7b6cd5994b3"
  end

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/47/6e/311d5f22e2b76381719b5d0c6e9dc39cd33999adae67db71d7279a6d70f4/pyxdg-0.26.tar.gz"
    sha256 "fe2928d3f532ed32b39c32a482b54136fe766d19936afc96c8f00645f9da1a06"
  end

  def install
    # avoid pycurl error about compile-time and link-time curl version mismatch
    ENV.delete "SDKROOT"

    xy = Language::Python.major_minor_version Formula["python@3.8"].opt_bin/"python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"

    # avoid error about libcurl link-time and compile-time ssl backend mismatch
    resource("pycurl").stage do
      system Formula["python@3.8"].opt_bin/"python3",
             *Language::Python.setup_install_args(libexec/"vendor"),
             "--curl-config=#{Formula["curl-openssl"].opt_bin}/curl-config"
    end

    resource("pyxdg").stage do
      system Formula["python@3.8"].opt_bin/"python3",
             *Language::Python.setup_install_args(libexec/"vendor")
    end

    inreplace "fb", "#!/usr/bin/env python", "#!#{Formula["python@3.8"].opt_bin}/python3"

    system "make", "PREFIX=#{prefix}", "install"
    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
  end

  test do
    system bin/"fb", "-h"
  end
end
