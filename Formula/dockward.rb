require "language/go"

class Dockward < Formula
  desc "Port forwarding tool for Docker containers"
  homepage "https://github.com/abiosoft/dockward"
  url "https://github.com/abiosoft/dockward/archive/0.0.4.tar.gz"
  sha256 "b96244386ae58aefb16177837d7d6adf3a9e6d93b75eea3308a45eb8eb9f4116"
  license "Apache-2.0"
  head "https://github.com/abiosoft/dockward.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f12be7e1ce960c12d1348a1b42aedbdacd7bd1cbe35f1833746b0bb9bb16b26a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "870ce371df50c4998c78435d70b882ab21a5abb90f5bd476397433f167c893e7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f9f6705d78dd9d8d596d92ca7dbde056b4954fdebb467c155064bb93f7e7b063"
    sha256 cellar: :any_skip_relocation, ventura:        "6457ba171a71b24d66a97ed30ece8b88dbce7410be014cc170ba93d6b40d5cda"
    sha256 cellar: :any_skip_relocation, monterey:       "f4ae4442fb735f9a74a0b29b666132660e7fc85a824fc467ff7d8ed8ee632bfa"
    sha256 cellar: :any_skip_relocation, big_sur:        "5287a1a8f985e8ecaba4a98eac278828e515bf4a8ba789ea68fd72a4243e8424"
    sha256 cellar: :any_skip_relocation, catalina:       "8abcf72ec26b59bab1b489e3233a137ebcc4a6d4bf3ccae10b7b062784d10e98"
    sha256 cellar: :any_skip_relocation, mojave:         "9c4eb789740a0b589faa9ccedcf3df90b6f68f1ab561806fe9aa750b91722800"
    sha256 cellar: :any_skip_relocation, high_sierra:    "50c2b838bbd89349e40050810a833cfea2803ac699cd006d47e796075be975b2"
    sha256 cellar: :any_skip_relocation, sierra:         "3dcac3afd57773d1c4b07b72f7f1bc9d66953dccccb0b3eadf7f40e43175d89b"
    sha256 cellar: :any_skip_relocation, el_capitan:     "b1b33f2b4db8242f9b422232d49bfde4c9b8fa0fa5053437366a9bc16795d9b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fab443a8e40b159ebd527d32138314a928589a52dd5fbfd69c52406ad3162ad9"
  end

  depends_on "go" => :build

  go_resource "github.com/Sirupsen/logrus" do
    url "https://github.com/Sirupsen/logrus.git",
        revision: "61e43dc76f7ee59a82bdf3d71033dc12bea4c77d"
  end

  go_resource "github.com/docker/distribution" do
    url "https://github.com/docker/distribution.git",
        revision: "7a0972304e201e2a5336a69d00e112c27823f554"
  end

  go_resource "github.com/docker/engine-api" do
    url "https://github.com/docker/engine-api.git",
        revision: "4290f40c056686fcaa5c9caf02eac1dde9315adf"
  end

  go_resource "github.com/docker/go-connections" do
    url "https://github.com/docker/go-connections.git",
        revision: "eb315e36415380e7c2fdee175262560ff42359da"
  end

  go_resource "github.com/docker/go-units" do
    url "https://github.com/docker/go-units.git",
        revision: "e30f1e79f3cd72542f2026ceec18d3bd67ab859c"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
        revision: "f2499483f923065a842d38eb4c7f1927e6fc6e6d"
  end

  def install
    ENV["GOBIN"] = bin
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    (buildpath/"src/github.com/abiosoft").mkpath
    ln_s buildpath, buildpath/"src/github.com/abiosoft/dockward"
    Language::Go.stage_deps resources, buildpath/"src"
    system "go", "install", "github.com/abiosoft/dockward"
  end

  test do
    output = shell_output(bin/"dockward -v")
    assert_match "dockward version #{version}", output
  end
end
