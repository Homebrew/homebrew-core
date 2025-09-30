class B4 < Formula
  include Language::Python::Virtualenv

  desc "Tool to work with public-inbox and patch archives"
  homepage "https://b4.docs.kernel.org/en/latest/"
  url "https://files.pythonhosted.org/packages/40/87/3489c1907e9338a3002ff3899d6a5b869aa215eedc0ee2e28ee6baf046fe/b4-0.14.2.tar.gz"
  sha256 "4f835b6e5ae30eff6004bb25c15fd8f4f6ecd1105596e86db1871fef7d18113d"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1e05e61e7fb5e79f83300de4f463aee0b354e389b8ac587065db2472e5c0754a"
    sha256 cellar: :any,                 arm64_sequoia: "78e1ab7fdd04911b6ec55f17cef7c4b56895669021ad06d40d5b04f47166d894"
    sha256 cellar: :any,                 arm64_sonoma:  "0a19827273be52f7f525549c1b973579ba381b5a1976942d567933fccbf99984"
    sha256 cellar: :any,                 arm64_ventura: "e89ba215ccb8788c2982d405535d8f75d536e97a1449a35ac85f0a80a62334b8"
    sha256 cellar: :any,                 sonoma:        "146022f8857fd125219db815b4a084ea8e5692693493fc66566f02914566844b"
    sha256 cellar: :any,                 ventura:       "fae976fa4a22be857ae5440ce1f0d02166187ee6620804133802d7db62c8f5ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "958e4f895da095812971882a90ff4bc28b1bcba79f6e067432a29eebf6c7a043"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27959dc1ca798d76a8085dc5fc410226d55f4c89da62226c8487d71d2dc203cb"
  end

  depends_on "certifi"
  depends_on "cffi"
  depends_on "libsodium"
  depends_on "python@3.13"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e4/33/89c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12d/charset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "dkimpy" do
    url "https://files.pythonhosted.org/packages/f0/6f/84e91828186bbfcedd7f9385ef5e0d369632444195c20e08951b7ffe0481/dkimpy-1.1.8.tar.gz"
    sha256 "b5f60fb47bbf5d8d762f134bcea0c388eba6b498342a682a21f1686545094b77"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/b5/4a/263763cb2ba3816dd94b08ad3a33d5fdae34ecb856678773cc40a3605829/dnspython-2.7.0.tar.gz"
    sha256 "ce9c432eda0dc91cf618a5cedf1a4e142651196bbcd2c80e89ed5a907e5cfaf1"
  end

  resource "git-filter-repo" do
    url "https://files.pythonhosted.org/packages/b9/bb/7a283f568af6b0528ade65e8ace84bd6ba46003e429101bcd62c232d01a5/git_filter_repo-2.47.0.tar.gz"
    sha256 "411b27e68a080c07a69c233cb526dbc2d848b09a72f10477f4444dd0822cf290"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "patatt" do
    url "https://files.pythonhosted.org/packages/fa/62/8adfadbc130cd33696e06c9c2f3ea36252c2e3dd1387cfdea0bc3aa10172/patatt-0.6.3.tar.gz"
    sha256 "980826f6529d2576c267ca1f564d5bef046cb47e54215bb598ed6c4b9b2d0a28"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/a7/22/27582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986da/PyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e1/0a/929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8/requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/b4 --version")

    (testpath/".gitconfig").write <<~EOS
      [user]
        name = Homebrew
        email = foo@brew.sh
    EOS
    assert_match "No thanks necessary.", shell_output("#{bin}/b4 ty 2>&1")
  end
end
