class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.23.5",
      revision: "98082eefab68b955090788b63bc5981f7dfea836"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "94690f5233d9c0ca875224fb27d2977fe0ce1810914591d40c8f35d81f70786d" => :catalina
    sha256 "d716acb148f6d65f1ec99cab93406f6a36cfbd07c82ea865e25dbbd7e03d5bf8" => :mojave
    sha256 "6face777ca58ad29ed4d798dc747ba0986e80f9d69e84dd710f7f8b24d37c6a1" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
             "-s -w -X github.com/derailed/k9s/cmd.version=#{version}
             -X github.com/derailed/k9s/cmd.commit=#{stable.specs[:revision]}",
             *std_go_args
  end

  test do
    assert_match "K9s is a CLI to view and manage your Kubernetes clusters.",
                 shell_output("#{bin}/k9s --help")
  end
end
