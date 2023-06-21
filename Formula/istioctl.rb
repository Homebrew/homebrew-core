class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://github.com/istio/istio.git",
      tag:      "1.18.0",
      revision: "697f4ff0fe6ee531bbd4f5f2a6b4b1f302c955a8"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e0b21cd846cac048ad729ad6013f97eb43a60a725f7ccc16fed43f6a1069c480"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0b21cd846cac048ad729ad6013f97eb43a60a725f7ccc16fed43f6a1069c480"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e0b21cd846cac048ad729ad6013f97eb43a60a725f7ccc16fed43f6a1069c480"
    sha256 cellar: :any_skip_relocation, ventura:        "723f2f7c6056219665bbe28cd3455d6d2cbc11ab42aec35a48ec6087509050ac"
    sha256 cellar: :any_skip_relocation, monterey:       "723f2f7c6056219665bbe28cd3455d6d2cbc11ab42aec35a48ec6087509050ac"
    sha256 cellar: :any_skip_relocation, big_sur:        "723f2f7c6056219665bbe28cd3455d6d2cbc11ab42aec35a48ec6087509050ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a83f7548b25ba84a918e1f7593373ad26ec17559a1aa06f1be6c3677495db98f"
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  uses_from_macos "curl" => :build

  def install
    ENV["VERSION"] = version.to_s
    ENV["TAG"] = version.to_s
    ENV["ISTIO_VERSION"] = version.to_s
    ENV["HUB"] = "docker.io/istio"
    ENV["BUILD_WITH_CONTAINER"] = "0"

    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s

    ENV.prepend_path "PATH", Formula["curl"].opt_bin if OS.linux?

    system "make", "istioctl"
    bin.install "out/#{os}_#{arch}/istioctl"

    generate_completions_from_executable(bin/"istioctl", "completion")
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/istioctl version --remote=false").strip
  end
end
