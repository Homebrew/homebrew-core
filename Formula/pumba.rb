class Pumba < Formula
  desc "Chaos testing tool for Docker"
  homepage "https://github.com/gaia-adm/pumba"
  url "https://github.com/gaia-adm/pumba/archive/0.4.7.tar.gz"
  sha256 "bf164c4179db969de5fcd4ea5bb807232cd6c6661d911fd648f41ace9f2f91b6"
  head "https://github.com/gaia-adm/pumba.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a6d7e9a983718448fb49b12d90eed052b480c88aaa355b41c26c3d746f5de14c" => :high_sierra
    sha256 "0ceec39dc8f0bf1c533ac8892f58d8b2773432bd8ca46ea6536bf343394efd31" => :sierra
    sha256 "939ac80f90e457260ba6af349ec3161779b9fba0d498f2bc00726deb4865adfe" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "docker" => :recommended

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"

    (buildpath/"src/github.com/gaia-adm/pumba").install buildpath.children

    cd "src/github.com/gaia-adm/pumba" do
      system "go", "build", "-o", bin/"pumba", "-ldflags",
             "-X main.Version=#{version}"
      prefix.install_metafiles
    end
  end

  test do
    output = pipe_output("#{bin}/pumba rm test-container 2>&1")
    assert_match "Is the docker daemon running?", output
  end
end
