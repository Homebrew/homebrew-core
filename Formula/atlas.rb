class Atlas < Formula
  desc "Database toolkit"
  homepage "https://atlasgo.io/"
  url "https://github.com/ariga/atlas/archive/v0.8.1.tar.gz"
  sha256 "185124844f39a32f7a15c92d7b1840edbac8a48c3b04f4afbe197729dd807db7"
  license "Apache-2.0"
  head "https://github.com/ariga/atlas.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "360c19e05de2f9fdfa041be4dd1c2717ede2ecdc9c270d7c8d9d5722674f964e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "655ab2e0bf9873755b86fc1efaa01e8bf169ea48e01348a76ed34f64728eb865"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e18cbe9b92244be59a9e30ecfcab2dee57b7714737ec36252ea8e6679065bf12"
    sha256 cellar: :any_skip_relocation, monterey:       "919aca7193738846918ed41a1caeaf4bcf3bcf9f446b3a51635532e868aced98"
    sha256 cellar: :any_skip_relocation, big_sur:        "1e93a15f6726a18ccd13b112f70b90eb0e37e794290aeb719011dadfa6498039"
    sha256 cellar: :any_skip_relocation, catalina:       "23c5d71cdfe2461a4cbc346a1dee1f85abf0b5461c6279de218307b04011dae7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af5776e6a01ad5b3e44c446af4dcbb55c80bbc5971d3f0b4bfc72bee3fcf4223"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X ariga.io/atlas/cmd/atlas/internal/cmdapi.version=v#{version}
    ]
    cd "./cmd/atlas" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    generate_completions_from_executable(bin/"atlas", "completion")
  end

  test do
    assert_match "Error: mysql: query system variables:",
      shell_output("#{bin}/atlas schema inspect -u \"mysql://user:pass@localhost:3306/dbname\" 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/atlas version")
  end
end
