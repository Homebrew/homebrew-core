class OdoDev < Formula
  desc "Developer-focused CLI for Kubernetes and OpenShift"
  homepage "https://odo.dev"
  url "https://github.com/redhat-developer/odo.git",
      tag:      "v2.5.1",
      revision: "ae0c553090e7644c3eda585639151419a8c3fb6b"
  license "Apache-2.0"
  head "https://github.com/redhat-developer/odo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5026ff52c68d73fc7981326856682ff9c48833657f750d7aa86dd1ec60bb270"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "018a78f5f9e9d5cda3d4e2aaf8e1eaa5c44a474044bda827f4c7f5142737f65b"
    sha256 cellar: :any_skip_relocation, monterey:       "d9322be68b4aec2b97c0b4eac766ce31393d8ec2f8bbb138e44e911a102c9a36"
    sha256 cellar: :any_skip_relocation, big_sur:        "5e4b468e5b613a38077b745f938fd99bbea16c47f1c04a255abaeaf06926b21b"
    sha256 cellar: :any_skip_relocation, catalina:       "6b9827adad64f018a9b43f70b5910d8feb72e64433b543bb743003ab598df346"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78f177ccb42d8bf3d93fef3682a7b11a185f4e59de9c9fd1ba9b640efc14015e"
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
