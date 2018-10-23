class Kubespy < Formula
  desc "Tools for observing Kubernetes resources in realtime"
  homepage "https://github.com/pulumi/kubespy"
  url "https://github.com/pulumi/kubespy.git",
      :tag      => "v0.4.0",
      :revision => "9cca3f1b07e33c5c8a11c804c9276cbb75338641"

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
