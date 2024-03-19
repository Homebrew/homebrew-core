class Mapcidr < Formula
  desc "Subnet/CIDR operation utility"
  homepage "https://projectdiscovery.io"
  url "https://github.com/projectdiscovery/mapcidr/archive/refs/tags/v1.1.16.tar.gz"
  sha256 "025607208fd7e8550f67510d35bb02a7b72d13ed609ff91c002736de26a08a43"
  license "MIT"
  head "https://github.com/projectdiscovery/mapcidr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "09f16f9c600d53c48b1e785b9a4dd97fac545d8758ca0afbcb41d109818a8929"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bff9ac8d6993fecccb516489d8b84ab37c771c996f30154c87d8f097c01361c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb34f662f83487573b8df716e31d77d2cd24302c3e38647ab4c1e17cf5edf5ab"
    sha256 cellar: :any_skip_relocation, sonoma:         "89fdf34cd833ab6156603d576f4f19e71f50004f046280f86f7b17528e23102e"
    sha256 cellar: :any_skip_relocation, ventura:        "cb2ef19f9c7905cd3e89a5422f6130363a3c711712f98be2b901862d0276cf4f"
    sha256 cellar: :any_skip_relocation, monterey:       "6b4772ad0343ce48d8de25efe20c2f391413cf1c2165846ab880fb57cac8439b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb95b94e17edf37aa6a2e78fe19945ffbe8371d5487f245a391e02cc64005b4a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/mapcidr"
  end

  test do
    expected = "192.168.0.0/18\n192.168.64.0/18\n192.168.128.0/18\n192.168.192.0/18\n"
    output = shell_output("#{bin}/mapcidr -cidr 192.168.1.0/16 -sbh 16384 -silent")
    assert_equal expected, output
  end
end
