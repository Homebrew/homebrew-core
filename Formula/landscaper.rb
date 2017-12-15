class Landscaper < Formula
  desc "Manage the application landscape in a Kubernetes cluster"
  homepage "https://github.com/Eneco/landscaper"
  url "https://github.com/Eneco/landscaper.git",
      :tag => "1.0.12",
      :revision => "26ac1fe512df4170a83b1f325d98673838aaa1a4"
  head "https://github.com/Eneco/landscaper.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "183246ed331441e2b3c68e11a62591685cee31a86ecd71b502376ed1a8f28e55" => :high_sierra
    sha256 "ca2ca5a91405dba1230e284f56eb290db13a9f3f595f76c72a85e51f46ee8fc5" => :sierra
    sha256 "44af281913b949c376dd0fd7e0abe78a171d971e457348062b93c2d77618fcf2" => :el_capitan
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
