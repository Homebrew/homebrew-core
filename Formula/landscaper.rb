class Landscaper < Formula
  desc "Manage the application landscape in a Kubernetes cluster"
  homepage "https://github.com/Eneco/landscaper"
  url "https://github.com/Eneco/landscaper.git",
      :tag      => "v1.0.24",
      :revision => "1199b098bcabc729c885007d868f38b2cf8d2370"
  head "https://github.com/Eneco/landscaper.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6ac6de3f445e382e6f03c339ef45268113dc8566e1fb8154a47e257611565592" => :catalina
    sha256 "d178824d2e212c303d702137ad51e9df746cd0b65d53e1e3c80aa69268965cb2" => :mojave
    sha256 "7394b4d8cef65cff64ad929b623a4eb8e0dc4eb7541e919d7eb128ec811b104b" => :high_sierra
    sha256 "c231a80ae46932dd67361637ffb2efb1a9906d6e11ff9cf73fae7ea855533649" => :sierra
  end

  depends_on "dep" => :build
  depends_on "go" => :build
  depends_on "kubernetes-cli"
  depends_on "kubernetes-helm"

  def install
    ENV["GOPATH"] = buildpath
    ENV.prepend_create_path "PATH", buildpath/"bin"
    ENV["TARGETS"] = "darwin/amd64"
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
