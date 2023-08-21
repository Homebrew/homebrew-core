class Grip < Formula
  include Language::Python::Virtualenv

  desc "GitHub Markdown previewer"
  homepage "https://github.com/joeyespo/grip"
  url "https://files.pythonhosted.org/packages/b9/7b/013fad0e29839decbdf8d3b96dbbfa155cbf0b470c7c03ba736d35280d41/grip-4.6.1.tar.gz"
  sha256 "a5e6ac48cd253892f0fbd0aaef3f74fe8169d8ed3d94a2e9be6bf1540e008e9f"
  license "MIT"
  revision 2

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d21cc3005461af05fb3066de25d04621de02c0df9dde5e065e584facc243ab36"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e9e444cacc4e1b7a2d97367e9fb227b499f89831a780c84ad5a27a23a0f7a28"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f034a537001bdf1b4ecce9f9bd5e8545f29a28649c0e4744774f062732757c9c"
    sha256 cellar: :any_skip_relocation, ventura:        "d65953b1d02446617ffaf65217ace2a1d18d2839ff675e128696a2eacf9dd299"
    sha256 cellar: :any_skip_relocation, monterey:       "bc5e3ebc10c36c3aebdd486447293b64869f6e19637ebd9227570ca9ada9d68f"
    sha256 cellar: :any_skip_relocation, big_sur:        "e2263523ec145ebcacefb1463c509f31ea642e7ef997ad003ba5b7b9abeccbef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6e238c050103ba090ac1e09ef867c2e2e11ab3a9189b9a26e5adcaf9e6d5669"
  end

  depends_on "pygments"
  depends_on "python-certifi"
  depends_on "python@3.11"

  resource "blinker" do
    url "https://files.pythonhosted.org/packages/e8/f9/a05287f3d5c54d20f51a235ace01f50620984bc7ca5ceee781dc645211c5/blinker-1.6.2.tar.gz"
    sha256 "4afd3de66ef3a9f8067559fb7a1cbe555c17dcbe15971b05d1b625c3e7abe213"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2a/53/cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67/charset-normalizer-3.2.0.tar.gz"
    sha256 "3bb3d25a8e6c0aedd251753a79ae98a093c7e7b471faa3aa9a93a81431987ace"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/72/bd/fedc277e7351917b6c4e0ac751853a97af261278a4c7808babafa8ef2120/click-8.1.6.tar.gz"
    sha256 "48ee849951919527a045bfe3bf7baa8a959c423134e1a5b98c05c20ba75a1cbd"
  end

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "flask" do
    url "https://files.pythonhosted.org/packages/4d/00/ef81c18da32fdfcde6381c315f4b11597fb6691180a330418848efee0ae7/Flask-2.3.2.tar.gz"
    sha256 "8c2f9abd47a9e8df7f0c3f091ce9497d011dc3b31effcf4c85a6e2b50f4114ef"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "itsdangerous" do
    url "https://files.pythonhosted.org/packages/7f/a1/d3fb83e7a61fa0c0d3d08ad0a94ddbeff3731c05212617dff3a94e097f08/itsdangerous-2.1.2.tar.gz"
    sha256 "5dbbc68b317e5e42f327f9021763545dc3fc3bfe22e6deb96aaf1fc38874156a"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "markdown" do
    url "https://files.pythonhosted.org/packages/87/2a/62841f4fb1fef5fa015ded48d02401cd95643ca03b6760b29437b62a04a4/Markdown-3.4.4.tar.gz"
    sha256 "225c6123522495d4119a90b3a3ba31a1e87a70369e03f14799ea9c0d7183a3d6"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/6d/7c/59a3248f411813f8ccba92a55feaac4bf360d29e2ff05ee7d8e1ef2d7dbf/MarkupSafe-2.1.3.tar.gz"
    sha256 "af598ed32d6ae86f1b747b82783958b1a4ab8f617b06fe68795c7f026abbdcad"
  end

  resource "path-and-address" do
    url "https://files.pythonhosted.org/packages/2b/b5/749fab14d9e84257f3b0583eedb54e013422b6c240491a4ae48d9ea5e44f/path-and-address-2.0.1.zip"
    sha256 "e96363d982b3a2de8531f4cd5f086b51d0248b58527227d43cf5014d045371b7"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/31/ab/46bec149bbd71a4467a3063ac22f4486ecd2ceb70ae8c70d5d8e4c2a7946/urllib3-2.0.4.tar.gz"
    sha256 "8d22f86aae8ef5e410d4f539fde9ce6b2113a001bb4d189e0aed70642d602b11"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/d1/7e/c35cea5749237d40effc50ed1a1c7518d9f2e768fcf30b4e9ea119e74975/Werkzeug-2.3.6.tar.gz"
    sha256 "98c774df2f91b05550078891dee5f0eb0cb797a522c757a2452b9cee5b202330"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "<strong>Homebrew</strong> is awesome",
                 pipe_output("#{bin}/grip - --export -", "**Homebrew** is awesome.")
  end
end
