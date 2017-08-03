class Pumba < Formula
  desc "Chaos testing tool for Docker"
  homepage "https://github.com/gaia-adm/pumba"
  url "https://github.com/gaia-adm/pumba/archive/0.4.4.tar.gz"
  sha256 "fdf11426752c69e79c2db10e2f57ef41c8b5d3d6815602ed11a95402b5db2d35"
  head "https://github.com/gaia-adm/pumba.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d0e3ddea696b33bf3da8c01a98817c4c038e940942e3586fc0695a694544cdb1" => :sierra
    sha256 "16b7fd8f80f264a5c1892f4c9645be4329cf34459ae8642e12446ce92027fb17" => :el_capitan
    sha256 "dc4154ec8e77b384a7c496d5cdb9909fb1d845d4f10120dd2a0963b590207cd0" => :yosemite
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
