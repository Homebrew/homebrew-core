class Coconut < Formula
  include Language::Python::Virtualenv

  desc "Simple, elegant, Pythonic functional programming"
  homepage "https://coconut-lang.org/"
  url "https://files.pythonhosted.org/packages/b9/0f/f8b531ee6351f1f5300b28efd5444aa618b7581b802d35cb5a40e240ea10/coconut-3.1.1.tar.gz"
  sha256 "14c5f502465f1b9dde0b0cefe5c5b6458433c724fcede5920faa2183ecebd4f2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c798770750510d063ba6a5dcdd9589b2f90812507e6b6be3e4b3554bcb8dc60b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "809cd64520fad15b178903684bc9c7cf4fb8dc9a7e0edd56ee9b095f468c3fa1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4fa49d34e455b95aeb873be72092c4c7af3c2ae73599e190eda80346f041520b"
    sha256 cellar: :any_skip_relocation, sonoma:         "d09404f8e53f1418bc3ce106730a92aae2e6d291d10351f0e3f963bceff59de0"
    sha256 cellar: :any_skip_relocation, ventura:        "45a61d08f8d867e33781a454304a9d582d731c37f4f7f8c36b0becd2d31cef30"
    sha256 cellar: :any_skip_relocation, monterey:       "810e286a1dd41fa4d8522dea008fa233621d857598f01cdf254a312f5f45b1c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "206d732301f0fadf40bac54f4ea6c129599acdbc5d7197215206e0c601ee21db"
  end

  depends_on "python@3.12"

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/e6/e3/c4c8d473d6780ef1853d630d581f70d655b4f8d7553c6997958c283039a2/anyio-4.4.0.tar.gz"
    sha256 "5aadc6a1bbb7cdb0bede386cac5e2940f5e2ff3aa20277e991cf028e0585ce94"
  end

  resource "async-generator" do
    url "https://files.pythonhosted.org/packages/ce/b6/6fa6b3b598a03cba5e80f829e0dadbb49d7645f523d209b2fb7ea0bbb02a/async_generator-1.10.tar.gz"
    sha256 "6ebb3d106c12920aaae42ccb6f787ef5eefdcdd166ea3d628fa8476abe712144"
  end

  resource "cpyparsing" do
    url "https://files.pythonhosted.org/packages/74/fe/7d45fc7fb67dd3cdaef4430c882b0b655e18ca45cf792d5feefb15f18ca2/cpyparsing-2.4.7.2.4.0.tar.gz"
    sha256 "ee3d2f262712ad252a640131687d1b25985127a5d9ba2e1200f3017165f2ee7d"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/5d/0f/2a8cf0881833cae8a2b50f0ce63ba4662c44473640c1feeb054f19d33459/prompt_toolkit-3.0.46.tar.gz"
    sha256 "869c50d682152336e23c4db7f74667639b5047494202ffe7670817053fd57795"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/90/c7/6dc0a455d111f68ee43f27793971cf03fe29b6ef972042549db29eec39a2/psutil-5.9.8.tar.gz"
    sha256 "6be126e3225486dff286a8fb9a06246a5253f4c7c53b475ea5f5ac934e64194c"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/8e/62/8336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31/pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/aa/60/5db2249526c9b453c5bb8b9f6965fcab0ddb7f40ad734420b3b421f7da44/setuptools-70.0.0.tar.gz"
    sha256 "f211a66637b8fa059bb28183da127d4e86396c991a942b028c6650d4319c3fd0"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/df/db/f35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557/typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"hello.coco").write <<~EOS
      "hello, world!" |> print
    EOS
    assert_match "hello, world!", shell_output("#{bin}/coconut -r hello.coco")
  end
end
