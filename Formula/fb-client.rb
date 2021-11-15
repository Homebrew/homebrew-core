class FbClient < Formula
  include Language::Python::Shebang

  desc "Shell-script client for https://paste.xinu.at"
  homepage "https://paste.xinu.at"
  url "https://paste.xinu.at/data/client/fb-2.1.1.tar.gz"
  sha256 "8fbcffc853b298a8497ab0f66b254c0c9ae4cbd31ab9889912a44a8c5c7cef0e"
  license "GPL-3.0-only"
  revision 3
  head "https://git.server-speed.net/users/flo/fb", using: :git

  livecheck do
    url :homepage
    regex(%r{Latest release:.*?href=.*?/fb[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3bc9c8e679824e4aa1881940c2f31388009a092e82a7dab9aeb194356a3512e1"
    sha256 cellar: :any,                 arm64_big_sur:  "a870e1dd933cdd27887bba730779541f1b9a118de7b77faafcd946a11987216a"
    sha256 cellar: :any,                 monterey:       "dce8cbedeb2a437cdc4fa837e6a793b884cf754a9f99e139bb419dca961ca710"
    sha256 cellar: :any,                 big_sur:        "15022e572c324e76d5b28922b1239f8ff8aba221bf2ed7cae49903ea85f9a4ae"
    sha256 cellar: :any,                 catalina:       "ca22959ea5179efb908e13f0463e2a7d4bc0127322166594524a8db3be1a6925"
    sha256 cellar: :any,                 mojave:         "d0681ab4b033fde92bcc83801c86342b1f97e27e849ea1404a7e8b3cf803a65c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8512aac59977ac082cb01cb01511c606c84b4daad6b95494b268ba6fe54c0e88"
  end

  depends_on "pkg-config" => :build
  depends_on "curl"
  depends_on "python@3.10"

  conflicts_with "spotbugs", because: "both install a `fb` binary"

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

    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor"/Language::Python.site_packages("python3")

    # avoid error about libcurl link-time and compile-time ssl backend mismatch
    resource("pycurl").stage do
      system "python3", *Language::Python.setup_install_args(libexec/"vendor"),
                        "--curl-config=#{Formula["curl"].opt_bin}/curl-config"
    end

    resource("pyxdg").stage do
      system "python3", *Language::Python.setup_install_args(libexec/"vendor")
    end

    rewrite_shebang detected_python_shebang, "fb"

    system "make", "PREFIX=#{prefix}", "install"
    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
  end

  test do
    system bin/"fb", "-h"
  end
end
