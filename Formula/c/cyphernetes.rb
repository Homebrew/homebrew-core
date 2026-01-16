class Cyphernetes < Formula
  desc "Kubernetes Query Language"
  homepage "https://cyphernet.es"
  url "https://github.com/AvitalTamir/cyphernetes/archive/refs/tags/v0.18.2.tar.gz"
  sha256 "98c48dbc4263854c74c9216274c8ec1cb327d9accbf0458f86c2231de8c889e9"
  license "Apache-2.0"
  head "https://github.com/AvitalTamir/cyphernetes.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "75b7e09d1628defdfceec77d3588840df8c7b9f5d6f4f2409f3a3b652b0e085a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75b7e09d1628defdfceec77d3588840df8c7b9f5d6f4f2409f3a3b652b0e085a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75b7e09d1628defdfceec77d3588840df8c7b9f5d6f4f2409f3a3b652b0e085a"
    sha256 cellar: :any_skip_relocation, sonoma:        "36eb2ee7fe1690f6a75f3b87fd33cda95826967af8322547fc3c39c39b81f5e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8bf78468cac60b77e2498a7bd74e7d7c07776f7389843a0a272a299f02acb5e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad94e1890dcd0a59a18fcef531ba649b1e8f5d9786b30754e79d5049229b8c14"
  end

  depends_on "go" => :build

  def install
    system "make", "operator-manifests"
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/cyphernetes"

    generate_completions_from_executable(bin/"cyphernetes", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/cyphernetes query 'MATCH (d:Deployment)->(s:Service) RETURN d' 2>&1", 1)
    assert_match("Error creating provider:  failed to create config: invalid configuration", output)

    assert_match version.to_s, shell_output("#{bin}/cyphernetes version")
  end
end
