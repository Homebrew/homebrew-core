require "language/go"

class Dockviz < Formula
  desc "Visualizing docker data"
  homepage "https://github.com/justone/dockviz"
  url "https://github.com/justone/dockviz.git", :tag => "v0.4",
                                                :revision => "551ef0434f74aa7ed0c8807b4e2dc9874a49160c"
  head "https://github.com/justone/dockviz.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1202c98b79daddeabc3ddf22e3fbf78e56af95cec0d1138c9fb52b0340ac9cf3" => :el_capitan
    sha256 "5ed747b159d50b803a1673b9e39b08684ccda4b3057760dc8d9c52130adf6117" => :yosemite
    sha256 "0599c6a868c4d1d6631b46b06ac2cb8572e9a26133ca3ee1c9fb20ddc3f0f9e3" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/Sirupsen/logrus" do
    url "https://github.com/Sirupsen/logrus.git",
    :revision => "cd7d1bbe41066b6c1f19780f895901052150a575"
  end

  go_resource "github.com/docker/docker" do
    url "https://github.com/docker/docker.git",
    :revision => "ac2f4dd71b9d1e7d028bf3e7cb3b662c109c5836"
  end

  go_resource "github.com/docker/go-units" do
    url "https://github.com/docker/go-units.git",
    :revision => "5d2041e26a699eaca682e2ea41c8f891e1060444"
  end

  go_resource "github.com/fsouza/go-dockerclient" do
    url "https://github.com/fsouza/go-dockerclient.git",
    :revision => "7cbfc4525fb2aeeeff56dc5c6fe18a5536a51f6b"
  end

  go_resource "github.com/hashicorp/go-cleanhttp" do
    url "https://github.com/hashicorp/go-cleanhttp.git",
    :revision => "ad28ea4487f05916463e2423a55166280e8254b5"
  end

  go_resource "github.com/jessevdk/go-flags" do
    url "https://github.com/jessevdk/go-flags.git",
    :revision => "6b9493b3cb60367edd942144879646604089e3f7"
  end

  go_resource "github.com/opencontainers/runc" do
    url "https://github.com/opencontainers/runc.git",
    :revision => "4ad7bbc172f2aed1ebaf5c0ddf1ea8c8136c2e93"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
    :revision => "2a35e686583654a1b89ca79c4ac78cb3d6529ca3"
  end

  def install
    ENV["GOPATH"] = buildpath
    Language::Go.stage_deps resources, buildpath/"src"
    system "go", "build", "-o", bin/"dockviz"
  end

  test do
    system "#{bin}/dockviz", "--version"
  end
end
