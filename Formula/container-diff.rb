class ContainerDiff < Formula
  desc "Diff your Docker containers"
  homepage "https://github.com/GoogleContainerTools/container-diff"
  url "https://github.com/GoogleContainerTools/container-diff/archive/v0.16.0.tar.gz"
  sha256 "255e08e82ffb9139b78054cd0caf0c20b1e6ab8fc359a9a8558da3912b70aba5"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "73d7844556e976b99cbe3e408b6412a7bf9970d7d1d7a9eb5dfb9b329afa236b" => :big_sur
    sha256 "8baffc25effb624f5882d57055512921276b4bc2e9067ed76b19e152f0109b59" => :catalina
    sha256 "31af3976b5c63927f934d3155de81d6b6a241bae7244d103012d0d7cbfbeded7" => :mojave
    sha256 "6002efa7d3d475f95c9bec04896e338a99da5bd333f6fc0ccd20ca80eb6e9726" => :high_sierra
    sha256 "20eeaca03031026c546e493be1fc57560f9495f621526dae1c07fd4ac5f5d189" => :sierra
  end

  depends_on "go" => :build

  def install
    pkg = "github.com/GoogleContainerTools/container-diff/version"
    system "go", "build", *std_go_args, "-ldflags", "-s -w -X #{pkg}.version=#{version}"
  end

  test do
    image = "daemon://gcr.io/google-appengine/golang:2018-01-04_15_24"
    output = shell_output("#{bin}/container-diff analyze #{image} 2>&1", 1)
    assert_match "error retrieving image daemon://gcr.io/google-appengine/golang:2018-01-04_15_24", output
  end
end
