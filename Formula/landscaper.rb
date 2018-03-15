class Landscaper < Formula
  desc "Manage the application landscape in a Kubernetes cluster"
  homepage "https://github.com/Eneco/landscaper"
  url "https://github.com/Eneco/landscaper.git",
      :tag => "v1.0.14",
      :revision => "c3a9ed96177c01491529b0eca7ba1d131a26e8e8"
  head "https://github.com/Eneco/landscaper.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8b2fecf7d17c03a29491a852335a274576c99e7ff947a0ccb5596fca6d6e1d9a" => :high_sierra
    sha256 "11ecd75994fb7fd79b7df4fa5a34bfd5cdd777cb220320dadc105682ae9623f9" => :sierra
    sha256 "972f4bcfa6ab71dee1a3971d898efab03760e12eaeb40c45f7a8038cd2c60903" => :el_capitan
  end

  depends_on "dep" => :build
  depends_on "go" => :build
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
