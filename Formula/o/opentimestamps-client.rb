class OpentimestampsClient < Formula
  include Language::Python::Virtualenv

  desc "Create and verify OpenTimestamps proofs"
  homepage "https://opentimestamps.org"
  url "https://files.pythonhosted.org/packages/3d/cb/15156c9bc8ab404e1fc2750a3b5aa4ecafccd632923776d61c875f116702/opentimestamps-client-0.7.2.tar.gz"
  sha256 "083a08f59c3123682d6742cc57d3e229ed7b3397807638836efe3a949517accb"
  license "LGPL-3.0-or-later"
  revision 6

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc301ba0dc8864a8e36d9964d402ff0c892c78b6e8e18538f969d41dc7f8d44b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9efeb4adb439dc33737534b59f7d277bbd8732de1cc28841952e001b61bd70bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94eeb48a179ca1d45d3c9d3f008f500bf36a68173f7efc94fe700313db4094c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "4cf4604465110fbffda2319dbe566c5c7ab7c250e7ced1e1282c6ed096dd073d"
    sha256 cellar: :any,                 arm64_linux:   "a4d12bdab5330e19ca216a700baf3b0ff62db64b6a637270cc222f97110baa70"
    sha256 cellar: :any,                 x86_64_linux:  "5e104f6ac16fb2bf66c58ccc2fc59c3e187d3cf9be510ab080a794889f57bff0"
  end

  depends_on "certifi" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: "certifi"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/72/94/63b0fc47eb32792c7ba1fe1b694daec9a63620db1e313033d18140c2320a/gitdb-4.0.12.tar.gz"
    sha256 "5ef71f855d191a3326fcfbc0d5da835f26b13fbcba60c32c21091c349ffdb571"
  end

  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/26/d6/5f358ff283325580c2003a6d953aea18cfe10ae87b46f5ebc80fa3a386dc/gitpython-3.1.58.tar.gz"
    sha256 "621416df10ef3fd0e19fabf9172ddeed0fa704d353d04f194eec56a625a95b22"
  end

  resource "opentimestamps" do
    url "https://files.pythonhosted.org/packages/fb/2a/5f19420091d137e5a4c49cbe3de1964a3741d3264bad5e0a528e54aaef15/opentimestamps-0.4.5.tar.gz"
    sha256 "56726ccde97fb67f336a7f237ce36808e5593c3089d68d900b1c83d0ebf9dcfa"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/c9/85/e24bf90972a30b0fcd16c73009add1d7d7cd9140c2498a68252028899e41/pycryptodomex-3.23.0.tar.gz"
    sha256 "71909758f010c82bc99b0abf4ea12012c98962fbf0583c2164f8b84533c2e4da"
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

    system libexec/"bin/python3.14", "-c", <<~PYTHON
      from opentimestamps.core.notary import PendingAttestation
      from opentimestamps.core.op import OpSHA256
      from opentimestamps.core.serialize import StreamSerializationContext
      from opentimestamps.core.timestamp import DetachedTimestampFile

      with open("input.txt", "rb") as f:
          detached = DetachedTimestampFile.from_fd(OpSHA256(), f)
      detached.timestamp.attestations.add(PendingAttestation("https://calendar.example"))
      with open("input.txt.ots", "wb") as out:
          detached.serialize(StreamSerializationContext(out))
    PYTHON

    output = shell_output("#{bin}/ots --no-cache info input.txt.ots")
    assert_match "File sha256 hash: d4de79205af8b0150c9cb0ea47d11c96bbc2236b89768a9a8d1028da8552994e", output
    assert_match "PendingAttestation('https://calendar.example')", output

    expected = "Ignoring attestation from calendar https://calendar.example: Calendar not in whitelist"
    verify_output = shell_output("#{bin}/ots --no-cache --no-default-whitelist \
                                            verify -f input.txt input.txt.ots 2>&1", 1)
    assert_match expected, verify_output
  end
end
