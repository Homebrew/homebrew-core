class ContainerDiff < Formula
  desc "Diff your Docker containers"
  homepage "https://github.com/GoogleContainerTools/container-diff"
  url "https://github.com/GoogleContainerTools/container-diff/archive/v0.16.0.tar.gz"
  sha256 "255e08e82ffb9139b78054cd0caf0c20b1e6ab8fc359a9a8558da3912b70aba5"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "055232f62b7ecc254a833115409dacb53eba5e2f367a79bf754d9e0d17f06711" => :big_sur
    sha256 "41fb6884547be02700c5e9281cbd42cf31fd1d089c74d54441b88038a9cbe147" => :arm64_big_sur
    sha256 "695d8f0fd299139e08f3bf5566a57943b001510849f13f259473414223ed5542" => :catalina
    sha256 "fc5c1f18d752bb0f5af502cbaec8af0ccb5fa1f600bfd892e5e1a01d8d7ded78" => :mojave
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
