class OdoDev < Formula
  desc "Developer-focused CLI for Kubernetes and OpenShift"
  homepage "https://odo.dev"
  url "https://github.com/redhat-developer/odo.git",
      tag:      "v2.5.0",
      revision: "724f16e689545dd4a81671da3e116a33df4832d3"
  license "Apache-2.0"
  head "https://github.com/redhat-developer/odo.git", branch: "main"

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
    assert_predicate testpath/"preference.yaml", :exist?

    # test version
    version_output = shell_output("#{bin}/odo version --client 2>&1").strip
    assert_match "odo #{version} (#{Utils.git_head})", version_output

    # almost all other odo commands require connection to OpenShift cluster
  end
end
