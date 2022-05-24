class Kind < Formula
  desc "Run local Kubernetes cluster in Docker"
  homepage "https://kind.sigs.k8s.io/"
  url "https://github.com/kubernetes-sigs/kind/archive/v0.14.0.tar.gz"
  sha256 "7850a3bb4c644622a1c643e63306ddcd76a5b729375df9bc97f87a82375b9439"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kind.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aae21435a83ef7c8e3abe321c708dde07a2169a849b98969d45f14539f4aec84"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "03a75bf5e690db31228c5a7c6933f5e320850b08891a23573b733acff97e6018"
    sha256 cellar: :any_skip_relocation, monterey:       "17fd618a994d1ac7f4b5b96b21d77f624315f6180b02260cccf81769d9d8f8ac"
    sha256 cellar: :any_skip_relocation, big_sur:        "f6ec6c1fad09f6c0647f15f70311291d31d632586b2fc9624d0e876c2d4a8a0c"
    sha256 cellar: :any_skip_relocation, catalina:       "17ab65161efe2a82e48fec0adda13593195e97c3433f879abf09ae55a7990ae7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b29f6a0492c893f1c8f421b5ea37f6180eb5bc1532f6f537777646eb00b66217"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    system "go", "build", *std_go_args

    # Install bash completion
    output = Utils.safe_popen_read("#{bin}/kind", "completion", "bash")
    (bash_completion/"kind").write output

    # Install zsh completion
    output = Utils.safe_popen_read("#{bin}/kind", "completion", "zsh")
    (zsh_completion/"_kind").write output

    # Install fish completion
    output = Utils.safe_popen_read("#{bin}/kind", "completion", "fish")
    (fish_completion/"kind.fish").write output
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    # Should error out as creating a kind cluster requires root
    status_output = shell_output("#{bin}/kind get kubeconfig --name homebrew 2>&1", 1)
    assert_match "Cannot connect to the Docker daemon", status_output
  end
end
