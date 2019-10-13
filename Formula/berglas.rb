class Berglas < Formula
  desc "Tool for managing secrets on Google Cloud"
  homepage "https://github.com/GoogleCloudPlatform/berglas"
  url "https://github.com/GoogleCloudPlatform/berglas/archive/v0.2.1.tar.gz"
  sha256 "31b25cfe81e72e8af9c6d856f714765be7acf204acf37f0ebae5d801bfe49e4c"

  bottle do
    cellar :any_skip_relocation
    sha256 "2248c0fe91fe9747dd4a1084e64952cfd362293745510633556aea2fba60fb4e" => :mojave
    sha256 "ac80c53eb4ad75196502f17cf8f3c530ff528d089f637204594dddfb3fe1ed9e" => :high_sierra
    sha256 "079084c82c8c9c1cfc88221d97e076b25b28c28bdb2d5a3c4711e90524af1853" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/GoogleCloudPlatform/berglas").install buildpath.children

    cd "src/github.com/GoogleCloudPlatform/berglas" do
      system "go", "build", "-o", bin/"berglas"
      prefix.install_metafiles
    end
  end

  test do
    assert_match "#{version}\n", shell_output("#{bin}/berglas --version 2>&1")
    out = shell_output("#{bin}/berglas list homebrewtest 2>&1", 60)
    assert_match "could not find default credentials.", out
  end
end
