class Govc < Formula
  desc "Command-line tool for VMware vSphere"
  homepage "https://github.com/vmware/govmomi/tree/master/govc"
  url "https://github.com/vmware/govmomi/archive/v0.26.0.tar.gz"
  sha256 "3b1b0aa46d7ce3d13be403d846bd50f366e91f6cadc42f64f11880fcb656dce4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bebb892475f09c66c21a608ec0f85b857e58057cdbe0ef95e8deefa4a4a6de7b"
    sha256 cellar: :any_skip_relocation, big_sur:       "e772a01c862af97db43ee1363c8b9a59ce301caef1ff44df8eb854014f74b99d"
    sha256 cellar: :any_skip_relocation, catalina:      "3fe08f149bb374ee7129f96f4aac5aa6f726544553c0a2d491c7b9842ef61dda"
    sha256 cellar: :any_skip_relocation, mojave:        "8af84ab070196731da857934837ad22e47b2735d7ad473973ae241300b4e1822"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "#{bin}/#{name}", "./#{name}"
  end

  test do
    assert_match "GOVC_URL=foo", shell_output("#{bin}/#{name} env -u=foo")
  end
end
