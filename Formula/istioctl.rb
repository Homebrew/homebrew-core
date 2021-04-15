class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://github.com/istio/istio.git",
      tag:      "1.9.3",
      revision: "6e4665c22b35447ab2c4509b37b4009b319ba945"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "f67083353bafc8108225fa4a3bbcaefef5bc1997bd9a57c6e8cf7f5cea9f3a48"
    sha256 cellar: :any_skip_relocation, catalina: "a6787f565c6ed4df34810fdd244aaadee684ae372c5ec30688fcddf6fa20e1b4"
    sha256 cellar: :any_skip_relocation, mojave:   "5346a08a81bfc74c2a40aee19de605f10ededcb4e05f8c23c7ddca408f27bd38"
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  def install
    ENV["VERSION"] = version.to_s
    ENV["TAG"] = version.to_s
    ENV["ISTIO_VERSION"] = version.to_s
    ENV["HUB"] = "docker.io/istio"
    ENV["BUILD_WITH_CONTAINER"] = "0"

    system "make", "gen-charts", "istioctl", "istioctl.completion"
    dirpath = nil
    on_macos do
      dirpath = "darwin_amd64"
    end
    on_linux do
      dirpath = "linux_amd64"
    end
    cd "out/#{dirpath}" do
      bin.install "istioctl"
      bash_completion.install "release/istioctl.bash"
      zsh_completion.install "release/_istioctl"
    end
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/istioctl version --remote=false").strip
  end
end
