class Epinio < Formula
  desc "CLI for Epinio, the Application Development Engine for Kubernetes"
  homepage "https://epinio.io/"
  url "https://github.com/epinio/epinio/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "4ac5924deb7b10119bcd51edd37bd32e20d3885cc760f23dbfe1a928564c0e32"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f9f6f3faa1e91085542bb071abf7f14e019af839a0bec485443a5584823bc02"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ddc336774c697824b6e36a904fc8660634438c8e4694ec1ab989b33f285eaf07"
    sha256 cellar: :any_skip_relocation, monterey:       "19c82dbc10d7d64fb6cb1c8ce75a1cce3a30fea39ee31e117a208594b285aba4"
    sha256 cellar: :any_skip_relocation, big_sur:        "02b526c3fa4ee87ffbaaae0831857de2c083c510c8dbb9f4b95986b3afb8f155"
    sha256 cellar: :any_skip_relocation, catalina:       "b3686e05609432b9c6724e14513e6625a10b6c9fd5cd2c56e55587cbb2b35cb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad8114eee036e4421486f1fe331e03cc84f6079f87d9ac0fab61949f4836cdbe"
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
