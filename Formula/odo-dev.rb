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
    shell_output("#{bin}/odo preference set ConsentTelemetry false")
    assert_predicate testpath/"preference.yaml", :exist?

    # test version
    version_output = shell_output("#{bin}/odo version --client 2>&1").strip
    tag = stable.instance_variable_get(:@resource).instance_variable_get(:@specs)[:tag]
    short_rev = stable.instance_variable_get(:@resource).instance_variable_get(:@specs)[:revision].slice(0, 9)
    assert_match "odo #{tag} (#{short_rev})", version_output

    # almost all other odo commands require connection to OpenShift cluster
  end
end
