class Landscaper < Formula
  desc "Manage the application landscape in a Kubernetes cluster"
  homepage "https://github.com/Eneco/landscaper"
  url "https://github.com/Eneco/landscaper.git",
      :tag => "v1.0.18",
      :revision => "b063fcef310cf7d5688610ccbfa710cd4eb41a4f"
  head "https://github.com/Eneco/landscaper.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "39cb038165465ccef0aea6389b341cf01590b53482194143b2bddde0cd5df8d0" => :high_sierra
    sha256 "9866d86d75adb68bcbec8ee0da54bae7da4052f6939f448f7a2f2063d85ee65a" => :sierra
    sha256 "72b598e9a06b1501a7a9c5b57a8bd01dd59e70bec67a2a3efbbd9ab46abb8b7d" => :el_capitan
  end

  depends_on "dep" => :build
  depends_on "go" => :build
  depends_on "kubernetes-cli"
  depends_on "kubernetes-helm"

  def install
    ENV["GOPATH"] = buildpath
    ENV.prepend_create_path "PATH", buildpath/"bin"
    arch = MacOS.prefer_64_bit? ? "amd64" : "x86"
    ENV["TARGETS"] = "darwin/#{arch}"
    dir = buildpath/"src/github.com/eneco/landscaper"
    dir.install buildpath.children - [buildpath/".brew_home"]

    cd dir do
      system "make", "bootstrap"
      system "make", "build"
      bin.install "build/landscaper"
      prefix.install_metafiles
    end
  end

  test do
    assert_match "This is Landscaper v#{version}", pipe_output("#{bin}/landscaper apply 2>&1")
  end
end
