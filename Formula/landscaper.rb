class Landscaper < Formula
  desc "Manage the application landscape in a Kubernetes cluster"
  homepage "https://github.com/Eneco/landscaper"
  url "https://github.com/Eneco/landscaper.git",
      :tag => "1.0.10",
      :revision => "c715c3b05d73ee8baf6b1c141524ff90ed80af2e"
  head "https://github.com/Eneco/landscaper.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "e228fa1fec10787234271815a0f35a2717f5c3116ca86a9e06da14bc21d484a6" => :high_sierra
    sha256 "73a870fc93d923eab2ee1f26f76bf350acf5de4e402f8447bf4ad9bcc4e01de8" => :sierra
    sha256 "6c50395eac33ac374a922ee454e41b96772c742cb4bb428c38b2a412f6e8e5b4" => :el_capitan
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
