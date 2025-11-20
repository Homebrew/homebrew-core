class BandcampDl < Formula
  include Language::Python::Virtualenv

  desc "Simple python script to download Bandcamp albums"
  homepage "https://github.com/evolution0/bandcamp-dl"
  url "https://files.pythonhosted.org/packages/78/c2/2c11878a494ceef38ed5ac51dede216547cb14ef40a30f8f009fca0ceab6/bandcamp_downloader-0.0.17.tar.gz"
  sha256 "d5e47777d0b1a14e49ba72d78ffa9b150e72af51d28e981231a0bd32c1c2e159"
  license "Unlicense"
  revision 2
  head "https://github.com/evolution0/bandcamp-dl.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "4d7a02493e7d856497e73b9b7051206046438f72f93c0c26c5905e1b5095335e"
  end

  depends_on "certifi"
  depends_on "python@3.14"

  pypi_packages exclude_packages: "certifi"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/77/e9/df2358efd7659577435e2177bfa69cba6c33216681af51a707193dec162a/beautifulsoup4-4.14.2.tar.gz"
    sha256 "2a98ab9f944a11acee9cc848508ec28d9228abfd522ef0fad6a02a72e0ded69e"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/83/2d/5fd176ceb9b2fc619e63405525573493ca23441330fcdaee6bef9460e924/charset_normalizer-3.4.3.tar.gz"
    sha256 "6fce4b8500244f6fcb71465d4a4930d132ba9ab8e71a7859e6a5d59851068d14"
  end

  resource "demjson3" do
    url "https://files.pythonhosted.org/packages/f7/d2/6a81a9b5311d50542e11218b470dafd8adbaf1b3e51fc1fddd8a57eed691/demjson3-3.0.6.tar.gz"
    sha256 "37c83b0c6eb08d25defc88df0a2a4875d58a7809a9650bd6eee7afd8053cdbac"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "mutagen" do
    url "https://files.pythonhosted.org/packages/81/e6/64bc71b74eef4b68e61eb921dcf72dabd9e4ec4af1e11891bbd312ccbb77/mutagen-1.47.0.tar.gz"
    sha256 "719fadef0a978c31b4cf3c956261b3c58b6948b32023078a2117b1de09f0fc99"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/6d/e6/21ccce3262dd4889aa3332e5a119a3491a95e8f60939870a3a035aabac0d/soupsieve-2.8.tar.gz"
    sha256 "e2dd4a40a628cb5f28f6d4b0db8800b8f581b65bb380b97de22ba5ca8d72572f"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "unicode-slugify" do
    url "https://files.pythonhosted.org/packages/ed/37/c82a28893c7bfd881c011cbebf777d2a61f129409d83775f835f70e02c20/unicode-slugify-0.1.5.tar.gz"
    sha256 "25f424258317e4cb41093e2953374b3af1f23097297664731cdb3ae46f6bd6c3"
  end

  resource "unidecode" do
    url "https://files.pythonhosted.org/packages/94/7d/a8a765761bbc0c836e397a2e48d498305a865b70a8600fd7a942e85dcf63/Unidecode-1.4.0.tar.gz"
    sha256 "ce35985008338b676573023acc382d62c264f307c8f7963733405add37ea2b23"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/".config").mkpath
    system bin/"bandcamp-dl", "https://iamsleepless.bandcamp.com/track/under-the-glass-dome"
    assert_path_exists testpath/"iamsleepless/under-the-glass-dome/Single - under-the-glass-dome.mp3"
  end
end
