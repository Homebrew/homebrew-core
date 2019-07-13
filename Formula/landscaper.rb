class Landscaper < Formula
  desc "Manage the application landscape in a Kubernetes cluster"
  homepage "https://github.com/Eneco/landscaper"
  url "https://github.com/Eneco/landscaper.git",
      :tag      => "v1.0.24",
      :revision => "1199b098bcabc729c885007d868f38b2cf8d2370"
  head "https://github.com/Eneco/landscaper.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cda7019ddf77729c76a01f8dcf6b99b041f715a98936ac599b6075c44f48ec14" => :mojave
    sha256 "9af1e83611a73e13d3e15c99de54276c612f6de031a6832fdb0e9bcd8d8b5b44" => :high_sierra
    sha256 "f9d5002f1d72b4654474328f4c4e3f0cfa1d18d6b24bbf48a4ef05df45a321a5" => :sierra
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
