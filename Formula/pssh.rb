class Pssh < Formula
  desc "Parallel versions of OpenSSH and related tools"
  homepage "https://code.google.com/archive/p/parallel-ssh/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/parallel-ssh/pssh-2.3.1.tar.gz"
  sha256 "539f8d8363b722712310f3296f189d1ae8c690898eca93627fc89a9cb311f6b4"

  bottle do
    cellar :any_skip_relocation
    sha256 "b4a9f92943bcfb34d5230d90658176ef5fe3a304f3abe48a1aad5fbda38c8efb" => :sierra
    sha256 "b13dcf5091ba493f21cd44c9ef43d028a4e23627b7b855ab4d299f0d543037a1" => :el_capitan
    sha256 "16f3c0b42cd3bfabea6a22a39b62299de53e1fb894b72da0c12574f25a09963a" => :yosemite
    sha256 "62595390d018a9a953928cf6adf8e9299b92f00c3846d74757a18437abbc5f27" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard

  conflicts_with "putty", :because => "both install `pscp` binaries"

  def install
    ENV["PYTHONPATH"] = lib/"python2.7/site-packages"

    system "python", "setup.py", "install", "--prefix=#{prefix}",
                                 "--install-data=#{share}"

    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system bin/"pssh", "--version"
  end
end
