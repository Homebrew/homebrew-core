class Httpx < Formula
  desc "Fast and multi-purpose HTTP toolkit"
  homepage "https://github.com/projectdiscovery/httpx"
  url "https://github.com/projectdiscovery/httpx/archive/refs/tags/v1.6.8.tar.gz"
  sha256 "4c6085552b0576e125e5268255aedcac63c833c4cb69c523c7951efd9d6868ff"
  license "MIT"
  head "https://github.com/projectdiscovery/httpx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "60d8b53589d638dd609a871181d563c8461b1849b1fd180e16af81554580ddd5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "db038d044f1d83d6fa968c85c34621fbd1a1899f8d2b184e6e4d68d91da89e65"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d8b59cd2339895f9175684d0b8ceeedada104c3203075ef6a22f9f6cd0e889ba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42f1acf7e3ca7c2a9113a77ab8b363a0f9c6841de8a934f6f2cbb0bf7c596b9d"
    sha256 cellar: :any_skip_relocation, sonoma:         "0c5d85e87b2ae3daa9dc6a3ce1ebcbf1781644a3c7a299010fd9110518c4a643"
    sha256 cellar: :any_skip_relocation, ventura:        "2857088c917cfd6767c4d7364eac413adcf23cda5d457c3999f41ffaea03f851"
    sha256 cellar: :any_skip_relocation, monterey:       "3044517776bac0a7ecafaaceb22ecc09154c3563880d04ac55b4cb860110def3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1637a9b90ccf7cc60055dee824acf5ebbc951ec13a73663a5eed8377584ac51"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/httpx"
  end

  test do
    output = JSON.parse(shell_output("#{bin}/httpx -silent -title -json -u example.org"))
    assert_equal 200, output["status_code"]
    assert_equal "Example Domain", output["title"]
  end
end
