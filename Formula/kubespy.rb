class Kubespy < Formula
  desc "Tools for observing Kubernetes resources in realtime"
  homepage "https://github.com/pulumi/kubespy"
  url "https://github.com/pulumi/kubespy.git",
      :tag      => "v0.5.0",
      :revision => "f8634fd17a81832d71b22f9566868572b7c957fb"

  bottle do
    cellar :any_skip_relocation
    sha256 "0bf331c5f6599d6529db49070e5a98f97f9c46a6683094c6a182438c6323c428" => :mojave
    sha256 "9919ac7b83faf8683989239d68d92ed626ef8665fd5bf4c4e52b6a0163614766" => :high_sierra
    sha256 "f6e255dfd78c4a77e64fdbb6b9ee25acbb3c3f8686e8f18e2bd404a1d6577a8c" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"
    dir = buildpath/"src/github.com/pulumi/kubespy"
    dir.install buildpath.children

    cd dir do
      system "make", "build"
      bin.install "kubespy"
      prefix.install_metafiles
    end
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/kubespy version")
  end
end
