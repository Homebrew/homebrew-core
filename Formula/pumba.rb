class Pumba < Formula
  desc "Chaos testing tool for Docker"
  homepage "https://github.com/alexei-led/pumba"
  url "https://github.com/alexei-led/pumba/archive/0.4.8.tar.gz"
  sha256 "a9688201e07299f0d9973a6b1570c99ac3e10312361718c0ba72c80801d95fe8"
  head "https://github.com/alexei-led/pumba.git"

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
    (buildpath/"src/github.com/alexei-led/pumba").install buildpath.children

    cd "src/github.com/alexei-led/pumba" do
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
