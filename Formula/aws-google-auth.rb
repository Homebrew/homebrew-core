class AwsGoogleAuth < Formula
  include Language::Python::Virtualenv

  desc "Acquire AWS credentials using Google Apps"
  homepage "https://github.com/cevoaustralia/aws-google-auth"
  url "https://github.com/cevoaustralia/aws-google-auth/archive/0.0.35.tar.gz"
  sha256 "9dee6cc48ae4d150193c60ececc968e6e7317eee3cac66b6d8593ebd6c819ed5"
  head "https://github.com/cevoaustralia/aws-google-auth.git"

  bottle do
    cellar :any
    sha256 "acfd3813af730b08a308d8cf3334b6f326eaa8ef534fb0b514a00c3da2c48f54" => :catalina
    sha256 "6ad0f0de1ee577d65c4766a9410d9bca0b1c260a48002f0c5ad7628857222600" => :mojave
    sha256 "9c1f55e791e73759a47f4800cc62cdd2f3bf6c75654427afd72a752c4a654c8c" => :high_sierra
  end

  depends_on "freetype"
  depends_on "jpeg"
  depends_on "python@3.8"

  uses_from_macos "libffi"
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/15/53/3692c565aea19f7d9dd696fee3d0062782e9ad5bf9535267180511a15967/soupsieve-2.0.tar.gz"
    sha256 "e914534802d7ffd233242b785229d5ba0766a7f487385e3f714446a07bf540ae"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/3b/e4/7cfc641f11e0eef60123912611a5c9ee7d4638da7325878b695b9ae4bb6f/beautifulsoup4-4.9.0.tar.gz"
    sha256 "594ca51a10d2b3443cbac41214e12dbb2a1cd57e1a7344659849e2e20ba6a8d8"
  end

  resource "Pillow" do
    url "https://files.pythonhosted.org/packages/81/1a/6b2971adc1bca55b9a53ed1efa372acff7e8b9913982a396f3fa046efaf8/Pillow-6.0.0.tar.gz"
    sha256 "809c0a2ce9032cbcd7b5313f71af4bdc5c8c771cb86eb7559afd954cab82ebb5"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/93/22/953e071b589b0b1fee420ab06a0d15e5aa0c7470eb9966d60393ce58ad61/docutils-0.15.2.tar.gz"
    sha256 "a2aeea129088da402665e92e0b25b04b073c04b2dce4ab65caaa38b7ce2e1a99"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/5c/40/3bed01fc17e2bb1b02633efc29878dfa25da479ad19a69cfb11d2b88ea8e/jmespath-0.9.5.tar.gz"
    sha256 "cca55c8d153173e21baa59983015ad0daf603f9cb799904ff057bfb8ff8dc2d9"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/21/9f/b251f7f8a76dec1d6651be194dfba8fb8d7781d10ab3987190de8391d08e/six-1.14.0.tar.gz"
    sha256 "236bdbdce46e6e6a3d61a337c0f8b763ca1e8717c03b369e87a7ec7ce1319c0a"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/be/ed/5bbc91f03fa4c839c4c7360375da77f9659af5f7086b7a7bdda65771c8e0/python-dateutil-2.8.1.tar.gz"
    sha256 "73ebfe9dbf22e832286dafa60473e4cd239f8592f699aa5adaf10050e6e1823c"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/05/8c/40cd6949373e23081b3ea20d5594ae523e681b6f472e600fbc95ed046a36/urllib3-1.25.9.tar.gz"
    sha256 "3018294ebefce6572a474f0604c2021e33b3fd8006ecd11d62107a5d2a963527"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/1b/aa/2a4ab9f8a2b4a87d3dc3451b0df9aa695707549d9d5206fefcefb31e8224/botocore-1.15.41.tar.gz"
    sha256 "a45a65ba036bc980decfc3ce6c2688a2d5fffd76e4b02ea4d59e63ff0f6896d4"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/50/de/2b688c062107942486c81a739383b1432a72717d9a85a6a1a692f003c70c/s3transfer-0.3.3.tar.gz"
    sha256 "921a37e2aefc64145e7b73d50c71bb4f26f46e4c9f414dc648c6245ff92cf7db"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/2b/5a/b54170621b5ab51a1661863bc37dae681b9e16c14b33aa5fa62822e53098/boto3-1.12.41.tar.gz"
    sha256 "c2c1ee703cb0fa03c5df84b7f00eaa462c808be477dc9014c1e8eef269122770"
  end

  resource "configparser" do
    url "https://files.pythonhosted.org/packages/e5/7c/d4ccbcde76b4eea8cbd73b67b88c72578e8b4944d1270021596e80b13deb/configparser-5.0.0.tar.gz"
    sha256 "2ca44140ee259b5e3d8aaf47c79c36a7ab0d5e94d70bd4105c03ede7a20ea5a1"
  end

  resource "entrypoints" do
    url "https://files.pythonhosted.org/packages/b4/ef/063484f1f9ba3081e920ec9972c96664e2edb9fdc3d8669b0e3b8fc0ad7c/entrypoints-0.3.tar.gz#sha256=c70dd71abe5a8c85e55e12c19bd91ccfeec11a6e99044204511f9ed547d48451"
    sha256 "c70dd71abe5a8c85e55e12c19bd91ccfeec11a6e99044204511f9ed547d48451"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/0b/2a/4abe0beccb37d125d77fd716d18c1a5cde509faa60a1b0d2e9bba13ec572/keyring-21.2.0.tar.gz"
    sha256 "197fd5903901030ef7b82fe247f43cfed2c157a28e7747d1cfcf4bc5e699dd03"
  end

  resource "keyrings.alt" do
    url "https://files.pythonhosted.org/packages/de/95/b127128917fef9ace8d8bfa66f3e3a81915d3dfa295d5f06784bca0c9854/keyrings.alt-3.4.0.tar.gz"
    sha256 "91328ac4229e70b1d0061d21bf61d36b031a6b4828f2682e38c741812f6eb23d"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/39/2b/0a66d5436f237aff76b91e68b4d8c041d145ad0a2cdeefe2c42f76ba2857/lxml-4.5.0.tar.gz"
    sha256 "8620ce80f50d023d414183bf90cc2576c2837b88e00bea3f33ad2630133bbb60"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/b8/e2/a3a86a67c3fc8249ed305fc7b7d290ebe5e4d46ad45573884761ef4dea7b/certifi-2020.4.5.1.tar.gz"
    sha256 "51fcb31174be6e6664c5f69e3e1691a2d72a1a12e90f872cbdb1567eb47b6519"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz#sha256=84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cb/19/57503b5de719ee45e83472f339f617b0c01ad75cba44aba1e4c97c2b0abd/idna-2.9.tar.gz"
    sha256 "7588d1c14ae4c77d74036e8c22ff447b26d0fde8f007354fd48a7814db15b7cb"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/f5/4f/280162d4bd4d8aad241a21aecff7a6e46891b905a4341e7ab549ebaf7915/requests-2.23.0.tar.gz"
    sha256 "b3f43d496c6daba4493e7c431722aeb7dbc6288f52a6e04e7b6023b0247817e6"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/57/6f/213d075ad03c84991d44e63b6516dd7d185091df5e1d02a660874f8f7e1e/tabulate-0.8.7.tar.gz"
    sha256 "db2723a20d04bcda8522165c73eea7c300eda74e0ce852d9022e0159d7895007"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/82/c3/534ddba230bd4fbbd3b7a3d35f3341d014cca213f369a9940925e7e5f691/pytz-2019.3.tar.gz"
    sha256 "b02c06db6cf09c12dd25137e563b31700d3b80fcc4ad23abb7a315f2789819be"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/c6/52/5ec375d4efcbe4e31805f3c4b301bdfcff9dcbdb3605d4b79e117a16b38d/tzlocal-2.0.0.tar.gz"
    sha256 "949b9dd5ba4be17190a80c0268167d7e6c92c62b30026cf9764caf3e308e5590"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/14/ec/6ee2168387ce0154632f856d5cc5592328e9cf93127c5c9aeca92c8c16cb/filelock-3.0.12.tar.gz"
    sha256 "18d82244ee114f543149c66a6e0c14e9c4f8a1044b5cdaadd0f82159d6a6ff59"
  end

  def install
    # Fix "ld: file not found: /usr/lib/system/libsystem_darwin.dylib" for lxml
    ENV["SDKROOT"] = MacOS.sdk_path if MacOS.version == :sierra

    venv = virtualenv_create(libexec, "python3")

    resource("entrypoints").stage do
      # Without removing this file, `pip` will ignore the `setup.py` file and
      # attempt to download the [`flit`](https://github.com/takluyver/flit)
      # build system.
      rm_f "pyproject.toml"

      venv.pip_install Pathname.pwd
    end

    resource("Pillow").stage do
      inreplace "setup.py" do |s|
        sdkprefix = MacOS.sdk_path_if_needed ? MacOS.sdk_path : ""
        s.gsub! "openjpeg.h",
          "probably_not_a_header_called_this_eh.h"
        s.gsub! "ZLIB_ROOT = None",
          "ZLIB_ROOT = ('#{sdkprefix}/usr/lib', '#{sdkprefix}/usr/include')"
        s.gsub! "JPEG_ROOT = None",
          "JPEG_ROOT = ('#{Formula["jpeg"].opt_prefix}/lib', '#{Formula["jpeg"].opt_prefix}/include')"
        s.gsub! "FREETYPE_ROOT = None",
          "FREETYPE_ROOT = ('#{Formula["freetype"].opt_prefix}/lib', '#{Formula["freetype"].opt_prefix}/include')"
      end

      # avoid triggering "helpful" distutils code that doesn't recognize Xcode 7 .tbd stubs
      unless MacOS::CLT.installed?
        ENV.append "CFLAGS", "-I#{MacOS.sdk_path}/System/Library/Frameworks/Tk.framework/Versions/8.5/Headers"
      end
      venv.pip_install Pathname.pwd
    end

    res = resources.map(&:name).to_set - ["entrypoints", "Pillow"]

    res.each do |r|
      venv.pip_install resource(r)
    end

    venv.pip_install_and_link buildpath
  end

  test do
    assert_match /Invalid username or password/,
      shell_output("echo 'foobar' | #{bin}/aws-google-auth -u foo -I C01111111 -S 111111111111 2>&1", 1)
  end
end
