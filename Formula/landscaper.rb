class Landscaper < Formula
  desc "Manage the application landscape in a Kubernetes cluster"
  homepage "https://github.com/Eneco/landscaper"
  url "https://github.com/Eneco/landscaper.git",
      :tag      => "v1.0.21",
      :revision => "df2a7d6a7db7a552576899b9fe8c85fdcc0af973"
  head "https://github.com/Eneco/landscaper.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "11265aaba50abe95269919c30b04a4684dc25d1ccf50823a20b7950963608e80" => :mojave
    sha256 "7c701bb9a5082cd20d7e32d75f7eb8c0d527de13381e0a92ffd9a632ef672b0a" => :high_sierra
    sha256 "5e01053b264faed028ad4fbea43019187f68f25b6350d4fc5cbd80c202ecb7ad" => :sierra
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
