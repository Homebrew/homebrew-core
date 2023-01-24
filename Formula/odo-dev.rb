class OdoDev < Formula
  desc "Developer-focused CLI for Kubernetes and OpenShift"
  homepage "https://odo.dev"
  url "https://github.com/redhat-developer/odo.git",
      tag:      "v3.6.0",
      revision: "5b4959272f71b2113f6d29f17d035bfd83781575"
  license "Apache-2.0"
  head "https://github.com/redhat-developer/odo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c70f33d350379c5fce13dff31cd14cf5e9e2a20a187c8c5e4cef2fb9f087c5f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c86fbce2de11da7aa85149bfa034e25fe746a55ccf5285aad198f368423ba6f5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8101b01b0a528decec5bd3e706b70820048e55a8d702de7f2acb0bdb77712d51"
    sha256 cellar: :any_skip_relocation, ventura:        "0d81f1c33e5e0cff9aa3d7f8bbe14c778f2239377dc5b0e89104336257f9b689"
    sha256 cellar: :any_skip_relocation, monterey:       "9188801fdb091d3d66d979d1ac38cde77b4e2d841fca7e8c962dba95e0360397"
    sha256 cellar: :any_skip_relocation, big_sur:        "b4b0ccc63312a0fd568cc914a47b73ce0717c6fb85174b6d31bc8c81bef1627f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0b6bdd1e031af7563a9ce8b4d5c5dbcb08201aea11fce33cad13c0ec5291c12"
  end

  depends_on "go" => :build
  conflicts_with "odo", because: "odo also ships 'odo' binary"

  def install
    system "make", "bin"
    bin.install "odo"
  end

  test do
    # try set preference
    ENV["GLOBALODOCONFIG"] = "#{testpath}/preference.yaml"
    system bin/"odo", "preference", "set", "ConsentTelemetry", "false"
    system bin/"odo", "preference", "add", "registry", "StagingRegistry", "https://registry.stage.devfile.io"
    assert_predicate testpath/"preference.yaml", :exist?

    # test version
    version_output = shell_output("#{bin}/odo version --client 2>&1").strip
    assert_match(/odo v#{version} \([a-f0-9]{9}\)/, version_output)

    # try to create a new component
    system bin/"odo", "init", "--devfile", "nodejs", "--name", "test", "--devfile-registry", "StagingRegistry"
    assert_predicate testpath/"devfile.yaml", :exist?

    dev_output = shell_output("#{bin}/odo dev 2>&1", 1).strip
    assert_match "no connection to cluster defined", dev_output
  end
end
