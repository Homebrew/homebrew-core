class FbClient < Formula
  desc "Shell-script client for https://paste.xinu.at"
  homepage "https://paste.xinu.at"
  url "https://paste.xinu.at/data/client/fb-2.0.4.tar.gz"
  sha256 "330c9593afd2b2480162786992d0bfb71be25faf105f3c24c71d514b58ee0cd3"
  revision 2
  head "https://git.server-speed.net/users/flo/fb", using: :git

  bottle do
    cellar :any
    sha256 "45db897c3f383834be56906412e419c2d203f3fd8ce1ce2d6077358890c7116e" => :catalina
    sha256 "b0d14486e7eb0927ac5b41f45f6effd6bb0999aa1c9ce50628fabd3090b5a2ab" => :mojave
    sha256 "f5456a27456904c7262ceb81fdfe12efcf01619ea85a67c8e3048189ecee720e" => :high_sierra
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
