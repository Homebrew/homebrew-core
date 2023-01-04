class OdoDev < Formula
  desc "Developer-focused CLI for Kubernetes and OpenShift"
  homepage "https://odo.dev"
  url "https://github.com/redhat-developer/odo.git",
      tag:      "v3.5.0",
      revision: "b98c4e2f5c6c7c456406331d7a07557cf2101a05"
  license "Apache-2.0"
  head "https://github.com/redhat-developer/odo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f25dbff0fdb72021b3be177f537d78dabbacf5ceff47ce1948c5b819a342662"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63a392a11d195c26694a87b890b13e7b65a37ad5f4d0de3cc5d34fb52bb9bddb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "32f133d239bf5ff8a9f75d503fe1e87f538ce0ef43f7f261c421c77be3f30bfe"
    sha256 cellar: :any_skip_relocation, ventura:        "ccaaa6cd6fcbb74b99228553d3c061b043f8f07b2948ebc43ba7bbdb17520790"
    sha256 cellar: :any_skip_relocation, monterey:       "e7752db58c05e66e324526b14fb3dd2be0133a4f9393f32395016ce14657f55a"
    sha256 cellar: :any_skip_relocation, big_sur:        "deefedaf77e77cfb7d625c7c43a93014287d9d3f3fa83713bf39e761f159c547"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38232e334b0ebbdd651924027b4ff6e7878ec248ae86a968327763b3264c2c02"
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
