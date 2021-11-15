class Keptn < Formula
  desc "Is the CLI for keptn.sh a message-driven control-plane for application delivery"
  homepage "https://keptn.sh"
  url "https://github.com/keptn/keptn/archive/0.9.2.tar.gz"
  sha256 "0ba9f79f3428baa2453622e19eeff2a325c36b35a5b22f60b4589ef77cc77826"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb25a124cf886aeb601ea8b44d9d2259f413ea1443dd25709beb8da024226e4b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a0face66e81013a059015062aed3855d75c151bd683f3f5b00eec5abd23ae0d6"
    sha256 cellar: :any_skip_relocation, monterey:       "4bbb3474e80d5bdd86d5b017a5c9421950920d3d2214ca11332ec9a3c99d62d8"
    sha256 cellar: :any_skip_relocation, big_sur:        "b8d83d543e45bf2a3287abc268d677cf33c79245a735146f12fec42e07278b1b"
    sha256 cellar: :any_skip_relocation, catalina:       "718d29d52f0e5780d0067f9b5eafad4a08a648b3bf605ab83ff939c547492b5c"
    sha256 cellar: :any_skip_relocation, mojave:         "920e3054b80aabed5310763a63c1af4a76ad680943771260cf77f4bffe4ab2b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bdba46209177a40c557bf9a4a517da9ec045e91065d34c46545b7d0d12f989e8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.KubeServerVersionConstraints=""
    ].join(" ")

    cd buildpath/"cli" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end
  end

  test do
    system bin/"keptn", "set", "config", "AutomaticVersionCheck", "false"
    system bin/"keptn", "set", "config", "kubeContextCheck", "false"

    assert_match "Keptn CLI version: #{version}", shell_output(bin/"keptn version 2>&1")

    assert_match "This command requires to be authenticated. See \"keptn auth\" for details",
      shell_output(bin/"keptn status 2>&1", 1)
  end
end
