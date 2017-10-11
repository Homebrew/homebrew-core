class Landscaper < Formula
  desc "Manage the application landscape in a Kubernetes cluster"
  homepage "https://github.com/Eneco/landscaper"
  url "https://github.com/Eneco/landscaper.git",
      :tag => "1.0.11",
      :revision => "4fd0758658b712e24f71a966eea7ab2bf0d8c15b"
  head "https://github.com/Eneco/landscaper.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "fe9570f84cdf1baf376e0c558cb034d922cc98e2f0c3652afe0fd5b6436db7f5" => :high_sierra
    sha256 "1a306751424fc1dca36efd98dc163a4f268ec9da70eeb3a643e2896a38f5d60d" => :sierra
    sha256 "6a2412371823a8c7c6886ded24d29831d45567a0fd54f5a970b7f25d9bdbd774" => :el_capitan
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
