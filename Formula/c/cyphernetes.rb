class Cyphernetes < Formula
  desc "Kubernetes Query Language"
  homepage "https://cyphernet.es"
  url "https://github.com/AvitalTamir/cyphernetes/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "cad9220829ad61429478cc08b2632063588ea763af3cd4806fa2ef94b7e3c354"
  license "Apache-2.0"

  depends_on "go" => :build
  depends_on "goyacc" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

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
