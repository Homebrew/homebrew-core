class Airshare < Formula
  include Language::Python::Virtualenv

  desc "Cross-platform content sharing in a local network"
  homepage "https://airshare.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/cb/a2/d59c18cd6a143bf860c29acb70552b7351fd7e0f56213be86b624601106b/Airshare-0.1.6.tar.gz"
  sha256 "138976933bcf2c0bc99f18901242544919e9fafe43735b4f83b19d4ae5964be7"
  license "MIT"
  revision 18

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "79f781d57a3cf6f5b6574cb69c5e1431e99b9b18715692da1dae5ed80c65a346"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d30bb4ba62d471a0c4a00f7d3d124899c1efe7ae34a35948b3bb93205c4d733"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c9179b2b2df7fb41d759ca1563294797c474ec25d768a8090791800eddf05ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "c63f6d1291cd4e986e102d5607d56a89067bd2e08ab2450e4f60db2b5bf9c2b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13a4f4c0abc104e6dc1079e5409a1202ef513377dd5fb6be57901004f1d61d23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e609f15de4b73eaeecb8510f4bd25fb4310609fd3115a8e0595bd5d574c6d67"
  end

  depends_on "python@3.14"

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/26/30/f84a107a9c4331c14b2b586036f40965c128aa4fee4dda5d3d51cb14ad54/aiohappyeyeballs-2.6.1.tar.gz"
    sha256 "c3f9d0113123803ccadfdf3f0faa505bc78e6a72d1cc4806cbd719826e943558"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/62/f1/8515650ac3121a9e55c7b217c60e7fae3e0134b5acfe65691781b5356929/aiohttp-3.13.0.tar.gz"
    sha256 "378dbc57dd8cf341ce243f13fa1fa5394d68e2e02c15cd5f28eae35a70ec7f67"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/61/62/06741b579156360248d1ec624842ad0edf697050bbaf7c3e46394e106ad1/aiosignal-1.4.0.tar.gz"
    sha256 "f47eecd9468083c2029cc99945502cb7708b082c232f9aca65da147157b251c7"
  end

  resource "asyncio" do
    url "https://files.pythonhosted.org/packages/71/ea/26c489a11f7ca862d5705db67683a7361ce11c23a7b98fc6c2deaeccede2/asyncio-4.0.0.tar.gz"
    sha256 "570cd9e50db83bc1629152d4d0b7558d6451bb1bfd5dfc2e935d96fc2f40329b"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/6b/5c/685e6633917e101e5dcb62b9dd76946cbb57c26e133bae9e0cd36033c0a9/attrs-25.4.0.tar.gz"
    sha256 "16d5969b87f0859ef33a48b35d55ac1be6e42ae49d5e853b597db70c35c57e11"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/4c/5b/b6ce21586237c77ce67d01dc5507039d444b630dd76611bbca2d8e5dcd91/certifi-2025.10.5.tar.gz"
    sha256 "47c09d31ccf2acf0be3f701ea53595ee7e0b8fa08801c6624be771df09ae7b43"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/83/2d/5fd176ceb9b2fc619e63405525573493ca23441330fcdaee6bef9460e924/charset_normalizer-3.4.3.tar.gz"
    sha256 "6fce4b8500244f6fcb71465d4a4930d132ba9ab8e71a7859e6a5d59851068d14"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/46/61/de6cd827efad202d7057d93e0fed9294b96952e188f7384832791c7b2254/click-8.3.0.tar.gz"
    sha256 "e7b8232224eba16f4ebe410c25ced9f7875cb5f3263ffc93cc3e8da705e229c4"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/2d/f5/c831fac6cc817d26fd54c7eaccd04ef7e0288806943f7cc5bbf69f3ac1f0/frozenlist-1.8.0.tar.gz"
    sha256 "3ede829ed8d842f6cd48fc7081d7a41001a56f1f38603f9d49bf3020d59a31ad"
  end

  resource "humanize" do
    url "https://files.pythonhosted.org/packages/98/1d/3062fcc89ee05a715c0b9bfe6490c00c576314f27ffee3a704122c6fd259/humanize-4.13.0.tar.gz"
    sha256 "78f79e68f76f0b04d711c4e55d32bebef5be387148862cb1ef83d2b58e7935a0"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "ifaddr" do
    url "https://files.pythonhosted.org/packages/e8/ac/fb4c578f4a3256561548cd825646680edcadb9440f3f68add95ade1eb791/ifaddr-0.2.0.tar.gz"
    sha256 "cc0cbfcaabf765d44595825fb96a99bb12c79716b73b44330ea38ee2b0c4aed4"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/80/1e/5492c365f222f907de1039b91f922b93fa4f764c713ee858d235495d8f50/multidict-6.7.0.tar.gz"
    sha256 "c6e99d9a65ca282e578dfea819cfa9c0a62b2499d8677392e09feaf305e9e6f5"
  end

  resource "propcache" do
    url "https://files.pythonhosted.org/packages/9e/da/e9fc233cf63743258bff22b3dfa7ea5baef7b5bc324af47a0ad89b8ffc6f/propcache-0.4.1.tar.gz"
    sha256 "f48107a8c637e80362555f37ecf49abe20370e557cc4ab374f04ec4423c97c3d"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/e8/52/d87eba7cb129b81563019d1679026e7a112ef76855d6159d24754dbd2a51/pyperclip-1.11.0.tar.gz"
    sha256 "244035963e4428530d9e3a6101a1ef97209c6825edab1567beac148ccc1db1b6"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/f3/61/d7545dafb7ac2230c70d38d31cbfe4cc64f7144dc41f6e4e4b78ecd9f5bb/requests-toolbelt-1.0.0.tar.gz"
    sha256 "7681a0a3d047012b5bdc0ee37d7f8f07ebe76ab08caeccfc3921ce23c88d5bc6"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/ca/6c/3d75c196ac07ac8749600b60b03f4f6094d54e132c4d94ebac6ee0e0add0/termcolor-3.1.0.tar.gz"
    sha256 "6a6dd7fbee581909eeec6a756cff1d7f7c376063b14e4a298dc4980309e55970"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/a8/4b/29b4ef32e036bb34e4ab51796dd745cdba7ed47ad142a9f4a1eb8e0c744d/tqdm-4.67.1.tar.gz"
    sha256 "f8aef9c52c08c13a65f30ea34f4e5aac3fd1a34959879d7e59e63027286627f2"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/57/63/0c6ebca57330cd313f6102b16dd57ffaf3ec4c83403dcb45dbd15c6f3ea1/yarl-1.22.0.tar.gz"
    sha256 "bebf8557577d4401ba8bd9ff33906f1376c877aa78d1fe216ad01b4d6745af71"
  end

  resource "zeroconf" do
    url "https://files.pythonhosted.org/packages/67/46/10db987799629d01930176ae523f70879b63577060d63e05ebf9214aba4b/zeroconf-0.148.0.tar.gz"
    sha256 "03fcca123df3652e23d945112d683d2f605f313637611b7d4adf31056f681702"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"airshare", shell_parameter_format: :click)
  end

  test do
    port = free_port
    pid = spawn bin/"airshare", "-p", port.to_s, "homebrew-demo", "-t", "Hello Homebrew!"
    sleep 30
    output = shell_output("#{bin}/airshare -p #{port} homebrew-demo")
    assert_equal "Received: Hello Homebrew!\n", output.lines.last
    Process.kill("TERM", pid)
  end
end
