class Binwalk < Formula
  include Language::Python::Virtualenv

  desc "Searches a binary image for embedded files and executable code"
  homepage "https://github.com/ReFirmLabs/binwalk"
  license "MIT"

  stable do
    # We use a fork for maintained v2 releases as documented by main repo.
    # Can consider switching back once v3 release is available.
    # Ref: https://github.com/ReFirmLabs/binwalk/tree/master?tab=readme-ov-file
    url "https://github.com/OSPG/binwalk/archive/refs/tags/v2.4.2.tar.gz"
    sha256 "36b11a4d245bce9663c2c17085282eb1012716c9f0f6754497126b1ad25cd4e7"

    depends_on "ninja" => :build
    depends_on "capstone"
    depends_on "freetype"
    depends_on "numpy"
    depends_on "pillow"
    depends_on "python@3.13"
    depends_on "qhull"

    on_linux do
      depends_on "patchelf" => :build
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "506a9dc4f71c32dbbc776b51b0c14f89b328fda5bb1ca353378cd2e84433c348"
    sha256 cellar: :any,                 arm64_sonoma:  "a4bffc734e4b661c4f9112d5a4e461eea14d54d2e5044c51cfdb3ce76958cd32"
    sha256 cellar: :any,                 arm64_ventura: "7a12626b14bc214cdd517510500213e56c68638ef6aca7eff35f140b0277e570"
    sha256 cellar: :any,                 sonoma:        "6026add10f56bdecc3f9889e8a62df72bf51532a747cae9c0a7c5efe564bff5d"
    sha256 cellar: :any,                 ventura:       "8ab2298e03a976787dfaac014c668bd6732b298f80fe231191ebfa2fb4bcd58d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb092294fbef182e109d711d98ac69441ecc3cf9ed8d55a6e9f6a605e9eaad82"
  end

  head do
    url "https://github.com/ReFirmLabs/binwalk.git", branch: "binwalkv3"

    depends_on "rust" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "p7zip"
  depends_on "xz"

  resource "capstone" do
    url "https://files.pythonhosted.org/packages/27/45/d811f0f3b345c8882b9179f7e310f222ba6af45f0cc729028cbf35c6ce03/capstone-5.0.3.tar.gz"
    sha256 "1f15616c0528f5268f2dc0a81708483e605ce71961b02a01a791230b51fe862d"
  end

  resource "contourpy" do
    url "https://files.pythonhosted.org/packages/f5/f6/31a8f28b4a2a4fa0e01085e542f3081ab0588eff8e589d39d775172c9792/contourpy-1.3.0.tar.gz"
    sha256 "7ffa0db17717a8ffb127efd0c95a4362d996b892c2904db72428d5b52e1938a4"
  end

  resource "cycler" do
    url "https://files.pythonhosted.org/packages/a9/95/a3dbbb5028f35eafb79008e7522a75244477d2838f38cbb722248dabc2a8/cycler-0.12.1.tar.gz"
    sha256 "88bb128f02ba341da8ef447245a9e138fae777f6a23943da4540077d3601eb1c"
  end

  resource "fonttools" do
    url "https://files.pythonhosted.org/packages/11/1d/70b58e342e129f9c0ce030029fb4b2b0670084bbbfe1121d008f6a1e361c/fonttools-4.54.1.tar.gz"
    sha256 "957f669d4922f92c171ba01bef7f29410668db09f6c02111e22b2bce446f3285"
  end

  resource "gnupg" do
    url "https://files.pythonhosted.org/packages/96/6c/21f99b450d2f0821ff35343b9a7843b71e98de35192454606435c72991a8/gnupg-2.3.1.tar.gz"
    sha256 "8db5a05c369dbc231dab4c98515ce828f2dffdc14f1534441a6c59b71c6d2031"
  end

  resource "kiwisolver" do
    url "https://files.pythonhosted.org/packages/85/4d/2255e1c76304cbd60b48cee302b66d1dde4468dc5b1160e4b7cb43778f2a/kiwisolver-1.4.7.tar.gz"
    sha256 "9893ff81bd7107f7b685d3017cc6583daadb4fc26e4a888350df530e41980a60"
  end

  resource "matplotlib" do
    url "https://files.pythonhosted.org/packages/9e/d8/3d7f706c69e024d4287c1110d74f7dabac91d9843b99eadc90de9efc8869/matplotlib-3.9.2.tar.gz"
    sha256 "96ab43906269ca64a6366934106fa01534454a69e471b7bf3d79083981aaab92"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/18/c7/8c6872f7372eb6a6b2e4708b88419fb46b857f7a2e1892966b851cc79fc9/psutil-6.0.0.tar.gz"
    sha256 "8faae4f310b6d969fa26ca0545338b21f73c6b15db7c4a8d934a5482faa818f2"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/13/52/13b9db4a913eee948152a079fe58d035bd3d1a519584155da8e786f767e6/pycryptodome-3.21.0.tar.gz"
    sha256 "f7787e0d469bdae763b876174cf2e6c0f7be79808af26b1da96f1a64bcf47297"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/83/08/13f3bce01b2061f2bbd582c9df82723de943784cf719a35ac886c652043a/pyparsing-3.1.4.tar.gz"
    sha256 "f86ec8d1a83f11977c9a6ea7598e8c27fc5cddfa5b07ea2241edbbde1d7bc032"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  def install
    if build.head?
      system "cargo", "install", *std_cargo_args
    else
      ENV["LIBCAPSTONE_PATH"] = Formula["capstone"].opt_lib
      venv = virtualenv_install_with_resources without: "matplotlib"

      # Use shared library from `capstone` formula
      pycapstone_lib = venv.site_packages/"capstone/lib"
      pycapstone_lib.mkpath
      libcapstone = Formula["capstone"].opt_lib/shared_library("libcapstone")
      ln_s libcapstone.relative_path_from(pycapstone_lib), pycapstone_lib

      # `matplotlib` needs extra inputs to use system libraries.
      # Ref: https://github.com/matplotlib/matplotlib/blob/v3.9.2/doc/install/dependencies.rst#use-system-libraries
      resource("matplotlib").stage do
        python = venv.root/"bin/python"
        system python, "-m", "pip", "install", "-Csetup-args=-Dsystem-freetype=true",
                                               "-Csetup-args=-Dsystem-qhull=true",
                                               *std_pip_args(prefix: false, build_isolation: true), "."
      end
    end
  end

  test do
    touch "binwalk.test"
    system bin/"binwalk", "binwalk.test"
  end
end
