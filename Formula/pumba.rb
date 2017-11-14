class Pumba < Formula
  desc "Chaos testing tool for Docker"
  homepage "https://github.com/gaia-adm/pumba"
  url "https://github.com/gaia-adm/pumba/archive/0.4.7.tar.gz"
  sha256 "bf164c4179db969de5fcd4ea5bb807232cd6c6661d911fd648f41ace9f2f91b6"
  head "https://github.com/gaia-adm/pumba.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "001f187281e483e7daa08153f0842bfcbf61a3388cacb0da5f9720769d4226f0" => :high_sierra
    sha256 "a3bc3d0a5b4a884f774fd7d0424442da279fd34dcff62b7992a4860c53f8cea5" => :sierra
    sha256 "825f70eb70fc84aa51ed3f9cfe5ecfb616ec1ee5201586d7c8fc4c09b809a74f" => :el_capitan
    sha256 "416382360c409b088e60055e2cd55dee70239eeb825709650395bcfd3a221858" => :yosemite
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
