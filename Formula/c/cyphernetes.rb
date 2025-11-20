class Cyphernetes < Formula
  desc "Kubernetes Query Language"
  homepage "https://cyphernet.es"
  url "https://github.com/AvitalTamir/cyphernetes/archive/refs/tags/v0.18.2.tar.gz"
  sha256 "98c48dbc4263854c74c9216274c8ec1cb327d9accbf0458f86c2231de8c889e9"
  license "Apache-2.0"
  head "https://github.com/AvitalTamir/cyphernetes.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b380ece361c7b87ff3e6994d6f5a688d79d7a4e489cf74c768a3bbffc346a51f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8e2d361e03bd89d0b809099a72eac56a8ab8ad739965a12cf7786733198e937"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8e2d361e03bd89d0b809099a72eac56a8ab8ad739965a12cf7786733198e937"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f8e2d361e03bd89d0b809099a72eac56a8ab8ad739965a12cf7786733198e937"
    sha256 cellar: :any_skip_relocation, sonoma:        "47d0c969b66651f145c08a2dc6c600677bb6e9ab82c94a56e502a416a8e17440"
    sha256 cellar: :any_skip_relocation, ventura:       "47d0c969b66651f145c08a2dc6c600677bb6e9ab82c94a56e502a416a8e17440"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33ffd997179ea645d2516af81580a4160ed9a9cf6e1fef5e7e5469e729d8bd13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "daa7cab1009d82326c2ad177bb5fbc6f03a8fd84ab4344a1784e3b30f1bd4208"
  end

  depends_on "go" => :build

  def install
    system "make", "operator-manifests"
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/cyphernetes"

    generate_completions_from_executable(bin/"cyphernetes", "completion")
  end

  test do
    output = shell_output("#{bin}/cyphernetes query 'MATCH (d:Deployment)->(s:Service) RETURN d' 2>&1", 1)
    assert_match("Error creating provider:  failed to create config: invalid configuration", output)

    assert_match version.to_s, shell_output("#{bin}/cyphernetes version")
  end
end
