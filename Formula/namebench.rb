class Namebench < Formula
  desc "DNS benchmark utility"
  homepage "https://code.google.com/archive/p/namebench/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/namebench/namebench-1.3.1-source.tgz"
  sha256 "30ccf9e870c1174c6bf02fca488f62bba280203a0b1e8e4d26f3756e1a5b9425"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "840fa253235f73ad6baed2034e809b523e4895229ad33d1374d5ffe63c33d117"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d599439f8524ed8a398ac60452bac1d333da837d8727ae9b84fc5f67f3d12dfa"
    sha256 cellar: :any_skip_relocation, monterey:       "e0962b652a267836132159970698b8dd79fbc6f985a4ee5877205046c5e64bf0"
    sha256 cellar: :any_skip_relocation, big_sur:        "072034ec4c593736c7a77e9de48f8d149794b2e3f6b000efb20e58b6bb3e7ddb"
    sha256 cellar: :any_skip_relocation, catalina:       "c958cb3841f9462efd7e2199cad803262dcb3b0b6ab766af53681910090e95e2"
    sha256 cellar: :any_skip_relocation, mojave:         "35225323dc77dc1954cd19b1aa0476e4ebab47e91dbabbfc7e169b5b500b0eba"
    sha256 cellar: :any_skip_relocation, high_sierra:    "4c2312daef0aae052b7e65bdb4b20cdcf1bfa601e5f8a484a7f846be1096bcb1"
    sha256 cellar: :any_skip_relocation, sierra:         "ae766151284842185ceecf1622a82cf55c949994729536015a42eea38f62309c"
    sha256 cellar: :any_skip_relocation, el_capitan:     "3333ef2615f6fbf294cede389d8545487474779a52c18108feb83a4697530cdc"
    sha256 cellar: :any_skip_relocation, yosemite:       "8d400aed171038f248e9d91718fb42625fc1f278df538b34259f26918b245f66"
  end

  deprecate! date: "2021-07-05", because: :unmaintained

  depends_on :macos # Due to Python 2

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"

    system "python", "setup.py", "install", "--prefix=#{libexec}",
                     "--install-data=#{libexec}/lib/python2.7/site-packages"

    bin.install "namebench.py" => "namebench"
    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
  end

  test do
    system bin/"namebench", "--query_count", "1", "--only", "8.8.8.8"
  end
end
