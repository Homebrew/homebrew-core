class Cyphernetes < Formula
  desc "Kubernetes Query Language"
  homepage "https://cyphernet.es"
  url "https://github.com/AvitalTamir/cyphernetes/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "cad9220829ad61429478cc08b2632063588ea763af3cd4806fa2ef94b7e3c354"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd1f56a19bf559202e80aec5d007b88c50edbb381e639ef94a41562a61484fdc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd1f56a19bf559202e80aec5d007b88c50edbb381e639ef94a41562a61484fdc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cd1f56a19bf559202e80aec5d007b88c50edbb381e639ef94a41562a61484fdc"
    sha256 cellar: :any_skip_relocation, sonoma:        "6618b575be9a0114269a344f705f7ad17f414a35d8d99c5d67498bf37bca8c8e"
    sha256 cellar: :any_skip_relocation, ventura:       "6618b575be9a0114269a344f705f7ad17f414a35d8d99c5d67498bf37bca8c8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b05277c846c456b00ddc1a03361bb6e8cde5c5baaae405ad27a483106048646b"
  end

  depends_on "go" => :build
  depends_on "goyacc" => :build

  def install
    system "make", "operator-manifests", "gen-parser"
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cyphernetes"

    generate_completions_from_executable(bin/"cyphernetes", "completion")
  end

  test do
    output = shell_output("#{bin}/cyphernetes query 'MATCH (d:Deployment)->(s:Service) RETURN d'", 1)

    assert_match("Error getting current context:  current context  does not exist in kubeconfig", output)
  end
end
