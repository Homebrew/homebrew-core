class Howdoi < Formula
  include Language::Python::Virtualenv

  desc "Instant coding answers via the command-line"
  homepage "https://github.com/gleitz/howdoi/"
  url "https://files.pythonhosted.org/packages/f1/04/765db9be1203a99789fb6b4443ff630e891274d3217332f7d3b0a64b4f3a/howdoi-1.1.10.tar.gz"
  sha256 "baea9bba67e13d71090cbce9cc2ce017ab286b2a2976a39d9a380f150495272c"

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "libxslt" unless OS.mac?

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/3d/7d/8d40fd42c16f9a9b1081857cef99b651743a86766e77b10bb59208f4d575/Pygments-2.1.1.tar.gz"
    sha256 "2df7d9a85b56e54c7c021dc98fc877bd216ead652c10da170779c004fb59c01b"
  end

  resource "argparse" do
    url "https://files.pythonhosted.org/packages/18/dd/e617cfc3f6210ae183374cd9f6a26b20514bbb5a792af97949c5aacddf0f/argparse-1.4.0.tar.gz"
    sha256 "62b089a55be1d8949cd2bc7e0df0bddb9e028faefc8c32038cc84862aefdd6e4"
  end

  resource "cssselect" do
    url "https://files.pythonhosted.org/packages/aa/e5/9ee1460d485b94a6d55732eb7ad5b6c084caf73dd6f9cb0bb7d2a78fafe8/cssselect-0.9.1.tar.gz"
    sha256 "0535a7e27014874b27ae3a4d33e8749e345bdfa62766195208b7996bf1100682"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/8b/be/ed850baac891aca25c832fb8d7b9c0e7a5077a30e336d95ffc7d649aaa06/lxml-3.5.0.tar.gz"
    sha256 "349f93e3a4b09cc59418854ab8013d027d246757c51744bf20069bc89016f578"
  end

  resource "pyquery" do
    url "https://files.pythonhosted.org/packages/e6/77/05b500811e360e53a254ca1f452e1e2f38b5284367e1172867b921d8020d/pyquery-1.2.11.tar.gz"
    sha256 "4a832ba73bfba03486f5445c75993a26bf62d38d26ff5fcfbde06a7bd0087fc6"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/f9/6d/07c44fb1ebe04d069459a189e7dab9e4abfe9432adcd4477367c25332748/requests-2.9.1.tar.gz"
    sha256 "c577815dd00f1394203fc44eb979724b098f88264a9ef898ee45b8e5e9cf587f"
  end

  resource "requests-cache" do
    url "https://files.pythonhosted.org/packages/8b/1a/873fafaff8bca751eee63e0827827bbc16bfce36ff8c368bb539a136d1b4/requests-cache-0.4.11.tar.gz"
    sha256 "d846e741a7c55ca8d586b4d3c437144fbd9cd680d1f6727c9bbbe3c29894187e"
  end

  def install
    # Fix "ld: file not found: /usr/lib/system/libsystem_darwin.dylib" for lxml
    ENV["SDKROOT"] = MacOS.sdk_path if MacOS.version == :sierra

    virtualenv_install_with_resources
  end

  test do
    ENV["LANG"] = "en_US.UTF-8"
    assert_match version.to_s, shell_output("#{bin}/howdoi --version 2>&1")
  end
end
