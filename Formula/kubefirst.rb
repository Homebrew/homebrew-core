class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https://kubefirst.io/"
  url "https://github.com/kubefirst/kubefirst/archive/refs/tags/1.11.0.tar.gz"
  sha256 "c9337a457befd64c8c5fd127aa43506b40568464e47de39cb0f96be797d5f78c"
  license "MIT"
  head "https://github.com/kubefirst/kubefirst.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e87aff901bcf9aaa344fc26b83c56c34938d4c69a9ff702361ccda8c6687bc1d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75f115cb0627380c9e6dc0ac4d321db5a225294245c10d084983ac90a5a98c60"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f576dc55050715290a53f16bd147b97823b24d0c133c4c1e024ab445c8b4df26"
    sha256 cellar: :any_skip_relocation, ventura:        "68d1f71c97ddba74162fb79049aa6de3fd1395e6ce20724179293ac807b0ca58"
    sha256 cellar: :any_skip_relocation, monterey:       "015bc1a2fa6511d8c4c4098e28f07b8700488c45513caf6800e1f27780d7efe1"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a495dfff569903444594d50e23feea8a951434e62f24aaee6971f9c1e66553b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba37692a69330392681c3af6b2ca798ffa68777908be04dd92ff9ab7ae89cce8"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/kubefirst/kubefirst/configs.K1Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"kubefirst", "completion")
  end

  test do
    system bin/"kubefirst", "info"
    assert_match "createdby: installer", (testpath/".kubefirst").read
    assert_predicate testpath/"logs", :exist?

    output = <<~EOS
      +------------------+--------------------+
      | ADDON NAME       | INSTALLED?         |
      +------------------+--------------------+
      | Addons Available | Supported by       |
      +------------------+--------------------+
      | kusk             | kubeshop/kubefirst |
      +------------------+--------------------+
    EOS
    assert_match output, shell_output("#{bin}/kubefirst addon list")

    assert_match version.to_s, shell_output("#{bin}/kubefirst version")
  end
end
