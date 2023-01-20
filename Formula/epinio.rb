class Epinio < Formula
  desc "CLI for Epinio, the Application Development Engine for Kubernetes"
  homepage "https://epinio.io/"
  url "https://github.com/epinio/epinio/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "8b07801efe93fc7eb8241dd05c57dd8ce1ed3568f88bfedf6340df996543cd2c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d47c5030452a296bbef0050052082db6ac76e397d829c24c20c58801a73317e9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d42d37b1dd79481b99f469f250c36b36deccca06a6c895048cd38a1075f18ab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f235710dc037061197cc4936163081cab358ad2c08b17311c97d09d1380a88e3"
    sha256 cellar: :any_skip_relocation, ventura:        "5e867c4fe63e81f66fbd2feb5724414550566d27d92761801219e843bedb5ebb"
    sha256 cellar: :any_skip_relocation, monterey:       "3b1c38e17fe15662cc322269a1c4d0eac1f397e12e955fecbab02f2c3acc11f9"
    sha256 cellar: :any_skip_relocation, big_sur:        "49439f5bd0564f34126032504740f7b0bddcdb4e6c8a6b893ffdd1d879f8286e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de0bc424fab752a1c117d705ba3a75d3daf1b8d51aab5ce5e3091ebc55108b6e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/epinio/epinio/internal/version.Version=#{version}")

    generate_completions_from_executable(bin/"epinio", "completion")
  end

  test do
    output = shell_output("#{bin}/epinio version 2>&1")
    assert_match "Epinio Version: #{version}", output

    output = shell_output("#{bin}/epinio settings update-ca 2>&1")
    assert_match "failed to get kube config", output
    assert_match "no configuration has been provided", output
  end
end
