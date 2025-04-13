class Cyphernetes < Formula
  desc "Kubernetes Query Language"
  homepage "https://cyphernet.es"
  url "https://github.com/AvitalTamir/cyphernetes/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "07458595e60f01f764bf4a98b7fdd45d934064efac12b68f4f1d2d0c9ad43bd2"
  license "Apache-2.0"
  head "https://github.com/AvitalTamir/cyphernetes.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d16a46528dbd86c54386cdbc4bc235e6c6cce92c6167e02ef45972357df49a77"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d16a46528dbd86c54386cdbc4bc235e6c6cce92c6167e02ef45972357df49a77"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d16a46528dbd86c54386cdbc4bc235e6c6cce92c6167e02ef45972357df49a77"
    sha256 cellar: :any_skip_relocation, sonoma:        "b3793b10dc8d9cb4f00bb1d32da4042e8f56c45ffde388a18ae272c9c834fd34"
    sha256 cellar: :any_skip_relocation, ventura:       "b3793b10dc8d9cb4f00bb1d32da4042e8f56c45ffde388a18ae272c9c834fd34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55135b1c34efe184c1397b5a048c3115a6f34fb8df7e5c0459d243f34304ac7f"
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
