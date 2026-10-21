class OpentimestampsClient < Formula
  include Language::Python::Virtualenv

  desc "Create and verify OpenTimestamps proofs"
  homepage "https://opentimestamps.org"
  url "https://files.pythonhosted.org/packages/3d/cb/15156c9bc8ab404e1fc2750a3b5aa4ecafccd632923776d61c875f116702/opentimestamps-client-0.7.2.tar.gz"
  sha256 "083a08f59c3123682d6742cc57d3e229ed7b3397807638836efe3a949517accb"
  license "LGPL-3.0-or-later"
  revision 8
  head "https://github.com/opentimestamps/opentimestamps-client.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cd9f9a3f9933051e2b82c35de8bcdb649e9ae15750f3d2d5ddadd18b4257c6fd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b0e708e46d6dea89f5c9fb6a150dfcc07a8bd7de38072c8eab0c42d833fee4ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3958e1c2d79128425341b1307b408faf0d45eaa724c1ea3d5cbcea2fd4094857"
    sha256 cellar: :any,                 arm64_linux:       "4476ebdb5c994a004d7339acb03d92c62e4d12b36741933567b8dfae90c2f780"
    sha256 cellar: :any,                 x86_64_linux:      "9e4c0691e341e9c756eeb1a65c30f11dd501f52a89a607ca0ac152ef47eea778"
  end

  depends_on "certifi" => :no_linkage
  depends_on "python@3.15"

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
    url "https://files.pythonhosted.org/packages/6e/2d/6f6e649818da44d4499604802c89329b8d9799687a124e3a5e467a643336/gitpython-3.2.0.tar.gz"
    sha256 "fb92310af6844d96adc95ca066ed2e617c00e1dbd146a326626c81e72e18cc2e"
  end

  resource "opentimestamps" do
    url "https://files.pythonhosted.org/packages/fb/2a/5f19420091d137e5a4c49cbe3de1964a3741d3264bad5e0a528e54aaef15/opentimestamps-0.4.5.tar.gz"
    sha256 "56726ccde97fb67f336a7f237ce36808e5593c3089d68d900b1c83d0ebf9dcfa"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/4c/25/214ea825a9031f5af2c8b2506ee16701a2560d4712165dd00098dd527bcb/pycryptodomex-3.24.0.tar.gz"
    sha256 "0428f19f13452c6b89bbaf2c530f84f369873811dfa77f0cee0da4f40fb0474f"
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
