class MoodleDl < Formula
  include Language::Python::Virtualenv

  desc "Downloads course content fast from Moodle (e.g., lecture PDFs)"
  homepage "https://github.com/C0D3D3V/Moodle-DL"
  url "https://files.pythonhosted.org/packages/0b/44/9c283a04b0ede0bcaa2f3595b523cb115c662fe349f215631484035126d1/moodle_dl-2.3.13.tar.gz"
  sha256 "7a6d813b3241497fb79a34a428aa266b2d2d3c175e05d46752e0a8040adaddce"
  license "GPL-3.0-or-later"
  revision 2

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b7c1eb9f9e8d542fdd898f72aaf90e4800ba01b5ff21da9323328e3fbcbbd910"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "594c23a3d9fa7f2038febc21c1ccba64767f42287a7815b79e6a0f5353d29ca8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "975decc7a4caffe571c4e0dc9cf0b61b560bf8bb9333ae933a31b2eef6c37773"
    sha256 cellar: :any_skip_relocation, sonoma:        "814b04138cba8bfe714e8bb5ad5134437888ef9818e1a28e5972a299cbb7dbaf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3648132d82cb041b6f521fc4f5d172d1841f4381ba0689a2eebdd60b564a0977"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68f27391724bf25debf4368a8fbdab085e0bfd24b11be28099b68d3348986330"
  end

  depends_on "certifi" => :no_linkage
  depends_on "ffmpeg"
  depends_on "python@3.14"

  uses_from_macos "libffi"

  pypi_packages exclude_packages: "certifi"

  resource "aiodns" do
    url "https://files.pythonhosted.org/packages/17/0a/163e5260cecc12de6abc259d158d9da3b8ec062ab863107dcdb1166cdcef/aiodns-3.5.0.tar.gz"
    sha256 "11264edbab51896ecf546c18eb0dd56dff0428c6aa6d2cd87e643e07300eb310"
  end

  resource "aiofiles" do
    url "https://files.pythonhosted.org/packages/41/c3/534eac40372d8ee36ef40df62ec129bee4fdb5ad9706e58a29be53b2c970/aiofiles-25.1.0.tar.gz"
    sha256 "a8d728f0a29de45dc521f18f07297428d56992a742f0cd2701ba86e44d23d5b2"
  end

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/26/30/f84a107a9c4331c14b2b586036f40965c128aa4fee4dda5d3d51cb14ad54/aiohappyeyeballs-2.6.1.tar.gz"
    sha256 "c3f9d0113123803ccadfdf3f0faa505bc78e6a72d1cc4806cbd719826e943558"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/ba/fa/3ae643cd525cf6844d3dc810481e5748107368eb49563c15a5fb9f680750/aiohttp-3.13.1.tar.gz"
    sha256 "4b7ee9c355015813a6aa085170b96ec22315dabc3d866fd77d147927000e9464"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/61/62/06741b579156360248d1ec624842ad0edf697050bbaf7c3e46394e106ad1/aiosignal-1.4.0.tar.gz"
    sha256 "f47eecd9468083c2029cc99945502cb7708b082c232f9aca65da147157b251c7"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/6b/5c/685e6633917e101e5dcb62b9dd76946cbb57c26e133bae9e0cd36033c0a9/attrs-25.4.0.tar.gz"
    sha256 "16d5969b87f0859ef33a48b35d55ac1be6e42ae49d5e853b597db70c35c57e11"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/eb/56/b1ba7935a17738ae8453301356628e8147c79dbb825bcbc73dc7401f9846/cffi-2.0.0.tar.gz"
    sha256 "44d1b5909021139fe36001ae048dbdde8214afa20200eda0f64c068cac5d5529"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "colorlog" do
    url "https://files.pythonhosted.org/packages/a2/61/f083b5ac52e505dfc1c624eafbf8c7589a0d7f32daa398d2e7590efa5fda/colorlog-6.10.1.tar.gz"
    sha256 "eb4ae5cb65fe7fec7773c2306061a8e63e02efc2c72eba9d27b0fa23c94f1321"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/2d/f5/c831fac6cc817d26fd54c7eaccd04ef7e0288806943f7cc5bbf69f3ac1f0/frozenlist-1.8.0.tar.gz"
    sha256 "3ede829ed8d842f6cd48fc7081d7a41001a56f1f38603f9d49bf3020d59a31ad"
  end

  resource "html2text" do
    url "https://files.pythonhosted.org/packages/f8/27/e158d86ba1e82967cc2f790b0cb02030d4a8bef58e0c79a8590e9678107f/html2text-2025.4.15.tar.gz"
    sha256 "948a645f8f0bc3abe7fd587019a2197a12436cd73d0d4908af95bfc8da337588"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/80/1e/5492c365f222f907de1039b91f922b93fa4f764c713ee858d235495d8f50/multidict-6.7.0.tar.gz"
    sha256 "c6e99d9a65ca282e578dfea819cfa9c0a62b2499d8677392e09feaf305e9e6f5"
  end

  resource "propcache" do
    url "https://files.pythonhosted.org/packages/9e/da/e9fc233cf63743258bff22b3dfa7ea5baef7b5bc324af47a0ad89b8ffc6f/propcache-0.4.1.tar.gz"
    sha256 "f48107a8c637e80362555f37ecf49abe20370e557cc4ab374f04ec4423c97c3d"
  end

  resource "pycares" do
    url "https://files.pythonhosted.org/packages/8d/ad/9d1e96486d2eb5a2672c4d9a2dd372d015b8d7a332c6ac2722c4c8e6bbbf/pycares-4.11.0.tar.gz"
    sha256 "c863d9003ca0ce7df26429007859afd2a621d3276ed9fef154a9123db9252557"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/fe/cf/d2d3b9f5699fb1e4615c8e32ff220203e43b248e1dfcc6736ad9057731ca/pycparser-2.23.tar.gz"
    sha256 "78816d4f24add8f10a06d6f05b4d424ad9e96cfebf68a4ddc99c65c0720d00c2"
  end

  resource "readchar" do
    url "https://files.pythonhosted.org/packages/dd/f8/8657b8cbb4ebeabfbdf991ac40eca8a1d1bd012011bd44ad1ed10f5cb494/readchar-4.2.1.tar.gz"
    sha256 "91ce3faf07688de14d800592951e5575e9c7a3213738ed01d394dcc949b79adb"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "sentry-sdk" do
    url "https://files.pythonhosted.org/packages/c9/b2/7481156cf42b7f66cffb371e504b7ace12b4f016b8872ffcf0873ae9534b/sentry_sdk-2.42.0.tar.gz"
    sha256 "91c69c9372fb5fb4df0ac39456ccf7286f0428b3ee1cdd389f9dd36c04e0f5c9"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "xmpppy" do
    url "https://files.pythonhosted.org/packages/22/bc/393e277f6d24675a741f795747fcb74f240ffa01c81e02b2e2678c415d16/xmpppy-0.7.2.tar.gz"
    sha256 "449bb158f99fd6cdd1e33dd52bc5a09aa79b7e4cc39fcd14f501ca3ecdec0f4e"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/57/63/0c6ebca57330cd313f6102b16dd57ffaf3ec4c83403dcb45dbd15c6f3ea1/yarl-1.22.0.tar.gz"
    sha256 "bebf8557577d4401ba8bd9ff33906f1376c877aa78d1fe216ad01b4d6745af71"
  end

  resource "yt-dlp" do
    url "https://files.pythonhosted.org/packages/03/b7/dab729345e22891e79294273bc59c5213a1ec87331f49cb82ccea2b1bc9f/yt_dlp-2025.10.14.tar.gz"
    sha256 "b18436aa9bb6f04354fd78d31ad9eeaae8c81b6a859f07072b25c18cd6c25844"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/moodle-dl --version")

    (testpath/"config.json").write <<~JSON
      {
        "token": "invalidtoken",
        "privatetoken": "invalidprivatetoken",
        "moodle_domain": "localhost",
        "moodle_path": "/moodle/"
      }
    JSON

    assert_match "Connection error", shell_output("#{bin}/moodle-dl 2>&1", 1)
    assert_path_exists testpath/"moodle_state.db"
  end
end
