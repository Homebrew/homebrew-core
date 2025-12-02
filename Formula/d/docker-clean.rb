class DockerClean < Formula
  desc "Clean Docker containers, images, networks, and volumes"
  homepage "https://github.com/ZZROTDesign/docker-clean"
  url "https://github.com/ZZROTDesign/docker-clean/archive/refs/tags/v2.0.4.tar.gz"
  sha256 "4b636fd7391358b60c05b65ba7e89d27eaf8dd56cc516f3c786b59cadac52740"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "8534cd2757101cb7ea6fc68d2175147769009a5b6bbab15d87bd5b83f46a06d6"
  end

  def install
    bin.install "docker-clean"
  end

  test do
    system bin/"docker-clean", "--help"
  end
end
