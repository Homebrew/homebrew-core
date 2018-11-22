class Kubespy < Formula
  desc "Tools for observing Kubernetes resources in realtime"
  homepage "https://github.com/pulumi/kubespy"
  url "https://github.com/pulumi/kubespy.git",
      :tag      => "v0.4.0",
      :revision => "9cca3f1b07e33c5c8a11c804c9276cbb75338641"

  bottle do
    cellar :any_skip_relocation
    sha256 "e3fff5273f5719aa828347b1d1b825874faac7989f240326ecf1ade567c1f47f" => :mojave
    sha256 "1f08465867b5108de94ec3e8bc68beb1af8af1300a3bcff246eff662c9d92c65" => :high_sierra
    sha256 "236a51cb10fd31ecd508ca2deb18c770edc9f850d9a3b30d85c737251269deba" => :sierra
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
