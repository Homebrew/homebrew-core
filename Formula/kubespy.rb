class Kubespy < Formula
  desc "Tools for observing Kubernetes resources in realtime"
  homepage "https://github.com/pulumi/kubespy"
  url "https://github.com/pulumi/kubespy.git",
      :tag      => "v0.5.1",
      :revision => "438edbfd5a9a72992803d45addb1f45b10a0b62f"

  bottle do
    cellar :any_skip_relocation
    sha256 "783702f8de5226fb50d35d30ee4f600f3c8ba82006e2ec52c6f643994f97ed65" => :catalina
    sha256 "0793f861231c44c23578b3c6d8faab29c868eb3ca4cc5786ad76536863fb04e0" => :mojave
    sha256 "a39ae5031e190cf58be0863d51738225366da5d36ede449af4146bd782b48e7a" => :high_sierra
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
