class Cariddi < Formula
  desc "Scan for endpoints, secrets, API keys, file extensions, tokens and more"
  homepage "https://github.com/edoardottt/cariddi"
  url "https://github.com/edoardottt/cariddi/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "7c99f35e92e936820992a540def7ee0165e75d4c765765c4f3f154e9f3d46f55"
  license "GPL-3.0-or-later"
  head "https://github.com/edoardottt/cariddi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9654c116bd6e57393a2a4462c56de10303c06ed36d6c9fc005f47a3e57c4d59b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df90cc2a4d39ace8958b937e3c9bff3a7e1f2043d2d927c0f6a18ddc3ec44e58"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "904056feff50692529eeaf0dc0f525b73f8f24b4ced280c1256755966e9fe858"
    sha256 cellar: :any_skip_relocation, sonoma:         "dbc6781ad98e104c16504482535e44903d8a03317c4729318124a55785940e41"
    sha256 cellar: :any_skip_relocation, ventura:        "8320b6a714be16a18bde882c9382078af75585441010d87838a89566a852528a"
    sha256 cellar: :any_skip_relocation, monterey:       "59c68010fcf11dc9645fc48e4522d207a13e4cf070eabe90f940ee2cf6ac57ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "854c85f44e3858fab8bf8465906117f802b23dc94bda359b619115bd1231f999"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cariddi"
  end

  test do
    output = pipe_output("#{bin}/cariddi", "http://testphp.vulnweb.com")
    assert_match "http://testphp.vulnweb.com/login.php", output

    assert_match version.to_s, shell_output("#{bin}/cariddi -version 2>&1")
  end
end
