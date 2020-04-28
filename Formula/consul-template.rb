class ConsulTemplate < Formula
  desc "Generic template rendering and notifications with Consul"
  homepage "https://github.com/hashicorp/consul-template"
  url "https://github.com/hashicorp/consul-template.git",
      :tag      => "v0.25.0",
      :revision => "edf364d29c5e2ab565081cd902cb37cb7a53bf11"
  head "https://github.com/hashicorp/consul-template.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "638d354403e9d6a2bbaa9003b3126276c3c7fccecfda84d60864db77d515c6f6" => :catalina
    sha256 "821aa1d4d9fd4c4e69e534c7d2b3cf978e8469418ed1f8ba189c785037a61efa" => :mojave
    sha256 "c203f4254f0ead3f5056967deb09277d479890709de81c3830f75542d055d43f" => :high_sierra
  end

  depends_on "go" => :build

  def install
    project = "github.com/hashicorp/consul-template"
    commit = Utils.popen_read("git rev-parse --short HEAD").chomp
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
