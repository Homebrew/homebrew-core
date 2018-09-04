class FbClient < Formula
  desc "Shell-script client for https://paste.xinu.at"
  homepage "https://paste.xinu.at"
  url "https://paste.xinu.at/data/client/fb-2.0.3.tar.gz"
  sha256 "dd318de67c1581e6dfa6b6c84e8c8e995b27d115fed86d81d5579aa9a2358114"
  revision 4
  head "https://git.server-speed.net/users/flo/fb", :using => :git

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "57a826c072389e851488aa7926270a6ad3c5202bd9d3a878bcaebdd4df8d186c" => :mojave
    sha256 "0ccd2fc01043e8f066d492105435ecf2230776d32873c1c2e389211efe5e4bc7" => :high_sierra
    sha256 "af9c5a5aab957f2e99cf1a7b86dd0b108408a61c4b7d8438f0c1e28840118b4d" => :sierra
    sha256 "f14ed5ba4447ed1161209080646351f3e4dcdf4d2872142d28d81b3a7fbcee4c" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "python"

  conflicts_with "findbugs", :because => "findbugs and fb-client both install a `fb` binary"

  resource "pycurl" do
    url "https://files.pythonhosted.org/packages/12/3f/557356b60d8e59a1cce62ffc07ecc03e4f8a202c86adae34d895826281fb/pycurl-7.43.0.tar.gz"
    sha256 "aa975c19b79b6aa6c0518c0cc2ae33528900478f0b500531dbcdbf05beec584c"
  end

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/26/28/ee953bd2c030ae5a9e9a0ff68e5912bd90ee50ae766871151cd2572ca570/pyxdg-0.25.tar.gz"
    sha256 "81e883e0b9517d624e8b0499eb267b82a815c0b7146d5269f364988ae031279d"
  end

  def install
    # avoid pycurl error about compile-time and link-time curl version mismatch
    ENV.delete "SDKROOT"

    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"

    # avoid error about libcurl link-time and compile-time ssl backend mismatch
    resource("pycurl").stage do
      args = Language::Python.setup_install_args(libexec/"vendor")

      if MacOS.version >= :high_sierra
        args << "--libcurl-dll=/usr/lib/libcurl.dylib"
      end

      system "python3", *args
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
