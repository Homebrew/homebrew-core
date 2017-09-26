class Landscaper < Formula
  desc "Manage the application landscape in a Kubernetes cluster"
  homepage "https://github.com/Eneco/landscaper"
  url "https://github.com/Eneco/landscaper.git",
      :tag => "1.0.10",
      :revision => "c715c3b05d73ee8baf6b1c141524ff90ed80af2e"
  head "https://github.com/Eneco/landscaper.git"

  bottle do
    cellar :any
    sha256 "6bbefd914dca42b8e3024e910461b43b8d173d5c9eb91a99fca205414bd2ce95" => :high_sierra
    sha256 "1c3f8a04554b7f3d71fd394ad8cffb8bc847be084477d52d55627e8e0e334a21" => :sierra
    sha256 "9939bfe87fb3b24290410d0fdae6dd34bce440ee2c78d2e65aef215fcec93782" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "glide" => :build
  depends_on "kubernetes-cli" => :run
  depends_on "kubernetes-helm" => :run

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"
    ENV.prepend_create_path "PATH", buildpath/"bin"
    arch = MacOS.prefer_64_bit? ? "amd64" : "x86"
    ENV["TARGETS"] = "darwin/#{arch}"
    dir = buildpath/"src/github.com/eneco/landscaper"
    dir.install buildpath.children - [buildpath/".brew_home"]

    cd dir do
      # Bootstap build
      system "make", "bootstrap"

      # Make binary
      system "make", "build"
      bin.install "build/landscaper"
    end
  end

  test do
    assert_match "This is Landscaper v#{version}", pipe_output("#{bin}/landscaper apply 2>&1")
  end
end
