require "language/go"

class Dockviz < Formula
  desc "Visualizing docker data"
  homepage "https://github.com/justone/dockviz"
  url "https://github.com/justone/dockviz.git",
    :tag => "v0.4.1",
    :revision => "8a7f88523842a7cf3594fb00ef3e72b3c33de81d"
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
    :revision => "f3cfb454f4c209e6668c95216c4744b8fddb2356"
  end

  go_resource "github.com/docker/docker" do
    url "https://github.com/docker/docker.git",
    :revision => "ee8c512dc32117fbd327b4a19da0ffefe47abfcd"
  end

  go_resource "github.com/docker/go-units" do
    url "https://github.com/docker/go-units.git",
    :revision => "09dda9d4b0d748c57c14048906d3d094a58ec0c9"
  end

  go_resource "github.com/fsouza/go-dockerclient" do
    url "https://github.com/fsouza/go-dockerclient.git",
    :revision => "9df1f25d542e79d7909ef321b5c13c5d34ea7f1d"
  end

  go_resource "github.com/hashicorp/go-cleanhttp" do
    url "https://github.com/hashicorp/go-cleanhttp.git",
    :revision => "ad28ea4487f05916463e2423a55166280e8254b5"
  end

  go_resource "github.com/jessevdk/go-flags" do
    url "https://github.com/jessevdk/go-flags.git",
    :revision => "b9b882a3990882b05e02765f5df2cd3ad02874ee"
  end

  go_resource "github.com/opencontainers/runc" do
    url "https://github.com/opencontainers/runc.git",
    :revision => "ae312e5155c4740b1c8ceb59a1a50be6390e49c2"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
    :revsion => "3f122ce3dbbe488b7e6a8bdb26f41edec852a40b"
  end

  def install
    ENV["GOPATH"] = buildpath
    Language::Go.stage_deps resources, buildpath/"src"
    system "go", "build", "-o", bin/"dockviz"
  end

  test do
    system bin/"dockviz", "--version"
  end
end
