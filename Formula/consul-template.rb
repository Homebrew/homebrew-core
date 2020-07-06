class ConsulTemplate < Formula
  desc "Generic template rendering and notifications with Consul"
  homepage "https://github.com/hashicorp/consul-template"
  url "https://github.com/hashicorp/consul-template.git",
      :tag      => "v0.25.0",
      :revision => "edf364d29c5e2ab565081cd902cb37cb7a53bf11"
  license "MPL-2.0"
  head "https://github.com/hashicorp/consul-template.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "18f8279c9d16c47dcd19f6847bee1e5559729902a4ac43861c41a16ff9475860" => :catalina
    sha256 "e6603f56f2d2bb333d8cd1eec11360aafacbd7dc7109b8f5dbf1233a5619779d" => :mojave
    sha256 "02412d96e01e84ee47af28e8107ee386e4a1cef01ea8df45ce4a108aefd52f44" => :high_sierra
  end

  depends_on "go" => :build

  def install
    project = "github.com/hashicorp/consul-template"
    commit = Utils.safe_popen_read("git", "rev-parse", "--short", "HEAD").chomp
    ldflags = %W[
      -s -w
      -X #{project}/version.Name=consul-template
      -X #{project}/version.GitCommit=#{commit}
    ]
    system "go", "build", "-ldflags", ldflags.join(" "), *std_go_args
    prefix.install_metafiles
  end

  test do
    (testpath/"template").write <<~EOS
      {{"homebrew" | toTitle}}
    EOS
    system bin/"consul-template", "-once", "-template", "template:test-result"
    assert_equal "Homebrew", (testpath/"test-result").read.chomp
  end
end
