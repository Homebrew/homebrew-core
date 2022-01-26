class OdoDev < Formula
  desc "Developer-focused CLI for Kubernetes and OpenShift"
  homepage "https://odo.dev"
  url "https://github.com/redhat-developer/odo.git",
      tag:      "v2.5.0",
      revision: "724f16e689545dd4a81671da3e116a33df4832d3"
  license "Apache-2.0"
  head "https://github.com/redhat-developer/odo.git", branch: "main"

  depends_on "go" => :build

  def install
    system "make", "bin"
    bin.install "odo"
  end

  test do
    # try set preference
    ENV["GLOBALODOCONFIG"] = "#{testpath}/preference.yaml"
    system bin/"odo", "preference", "set", "ConsentTelemetry", "false"
    assert_predicate testpath/"preference.yaml", :exist?

    # test version
    version_output = shell_output("#{bin}/odo version --client 2>&1").strip
    assert_match(/odo v#{version} \([a-f0-9]{9}\)/, version_output)

    # try to creation new component
    system bin/"odo", "create", "nodejs"
    assert_predicate testpath/"devfile.yaml", :exist?

    push_output = shell_output("#{bin}/odo push 2>&1", 1).strip
    assert_match("invalid configuration", push_output)
  end
end
