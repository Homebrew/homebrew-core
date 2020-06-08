class ConsulTemplate < Formula
  desc "Generic template rendering and notifications with Consul"
  homepage "https://github.com/hashicorp/consul-template"
  url "https://github.com/hashicorp/consul-template.git",
      :tag      => "v0.25.0",
      :revision => "edf364d29c5e2ab565081cd902cb37cb7a53bf11"
  head "https://github.com/hashicorp/consul-template.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "77a1af87ecaca41eb729f51fd37eb6f4a77b24025f84cf1db131b867c839a273" => :catalina
    sha256 "cee50257ce590058be3c5a0962d95d5c332d67f38982f5315ad78d67ffce2323" => :mojave
    sha256 "5589f360ea103acdb601bcd3cd1552ec2d06418c175509cd762cd35a97c1f22e" => :high_sierra
  end

  depends_on "go" => :build

  def install
    project = "github.com/hashicorp/consul-template"
    commit = Utils.safe_popen_read("git rev-parse --short HEAD").chomp
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
