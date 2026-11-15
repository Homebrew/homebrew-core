class OpentimestampsClient < Formula
  include Language::Python::Virtualenv

  desc "Create and verify OpenTimestamps proofs"
  homepage "https://opentimestamps.org"
  url "https://files.pythonhosted.org/packages/53/d0/f4dafe2577576515fc7b55324c6404cb2008b584c1c7cc29343a2340b59d/opentimestamps_client-0.8.0.tar.gz"
  sha256 "df8a25be1163bb46b410f6e43e0129ca18427d0d16d2890164a1fda7e5199d1c"
  license "LGPL-3.0-or-later"
  head "https://github.com/opentimestamps/opentimestamps-client.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3dd60a953f8a5f63ee98b8bb6784c2bf17a44a7dc199f48a03f1d71876b007db"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7346c8ce085d1a05358ab09517df516bd57de3db3863a371c9ddeded1cec0c7b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8449fa8d7cc6e201e2e28a0fd8871c2da2dabbeb3a47507d23a5b7488c934646"
    sha256 cellar: :any,                 arm64_linux:       "db8c8f05744477ef90fb66e7b70f0e39dd54f642205d7cc6ccdc1df6e924d954"
    sha256 cellar: :any,                 x86_64_linux:      "7e445f137cc8216e3f66ea65f0d40dd46a00fe3ef03664ce0be982c348d52c59"
  end

  depends_on "certifi" => :no_linkage
  depends_on "python@3.15"

  pypi_packages exclude_packages: "certifi"

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/72/94/63b0fc47eb32792c7ba1fe1b694daec9a63620db1e313033d18140c2320a/gitdb-4.0.12.tar.gz"
    sha256 "5ef71f855d191a3326fcfbc0d5da835f26b13fbcba60c32c21091c349ffdb571"
  end

  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/c0/ff/fee293f1ec3e1b64db6eb270e00964f29c086d769201474cedb8d1608930/gitpython-3.2.1.tar.gz"
    sha256 "0f1229ec5c057bdabdeeda8bda4f17bda679ab33dbccc00f24e6a480553c8613"
  end

  resource "opentimestamps" do
    url "https://files.pythonhosted.org/packages/f5/f3/d99d0fee5bbfe7a36c62b89067a0f802fb107bc5c7cd720912640c840a6f/opentimestamps-0.5.0.tar.gz"
    sha256 "c38e20e3970b821273c827a14365d3f8542aad390f26f340091daf10d4d2e428"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/1a/43/8c4b5fe23f0e119cf4e1b16c2d16240ab9057cdbb138568c91d5a48abf81/platformdirs-4.13.6.tar.gz"
    sha256 "211d176e24674b5895dedf9021c262bcf9fad008a70610bfb147d4a8d6d8fe1b"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/f4/e7/50e72301e32acb73a314e663c2014e1ddefc019d5f434ff14ec89861d664/pycryptodomex-3.24.1.tar.gz"
    sha256 "09081666ffc599976c0b8b29caf2cf82212c0f05bed233c8f8ed53e4f6e1d356"
  end

  resource "pysocks" do
    url "https://files.pythonhosted.org/packages/bd/11/293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11/PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "python-bitcoinlib" do
    url "https://files.pythonhosted.org/packages/90/a1/ca9d770094a0bfd0f2ce66b7180f0a7729b1b646d90f37f6debf38b28fab/python-bitcoinlib-0.12.2.tar.gz"
    sha256 "c65ab61427c77c38d397bfc431f71d86fd355b453a536496ec3fcb41bd10087d"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/1f/ea/49c993d6dfdd7338c9b1000a0f36817ed7ec84577ae2e52f890d1a4ff909/smmap-5.0.3.tar.gz"
    sha256 "4d9debb8b99007ae47165abc08670bd74cb74b5227dda7f643eccc4e9eb5642c"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"input.txt").write("homebrew test input")

    system bin/"ots", "stamp", "input.txt"
    assert_path_exists testpath/"input.txt.ots"

    output = shell_output("#{bin}/ots info input.txt.ots")
    assert_match "File sha256 hash: d4de79205af8b0150c9cb0ea47d11c96bbc2236b89768a9a8d1028da8552994e", output
    assert_match "PendingAttestation('https://btc.calendar.catallaxy.com')", output

    output = shell_output("#{bin}/ots --no-default-whitelist verify -f input.txt input.txt.ots 2>&1", 1)
    assert_match "Ignoring attestation from calendar", output
  end
end
