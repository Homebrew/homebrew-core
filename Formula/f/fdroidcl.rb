class Fdroidcl < Formula
  desc "F-Droid desktop client"
  homepage "https://github.com/mvdan/fdroidcl"
  url "https://github.com/mvdan/fdroidcl/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "917bd9e33ec895ef7de5e82e08d36a36bdf82dc9fd810520cc657be2d8d44106"
  license "BSD-3-Clause"
  head "https://github.com/mvdan/fdroidcl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43a2344ed4ad381157a0af5757f64b57f888184fa3c30aa44cf009bf00e0567d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43a2344ed4ad381157a0af5757f64b57f888184fa3c30aa44cf009bf00e0567d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "43a2344ed4ad381157a0af5757f64b57f888184fa3c30aa44cf009bf00e0567d"
    sha256 cellar: :any_skip_relocation, sonoma:        "505ecb1a25b1532e4c4f164e4be67e64ce66380de9502dbeda2ff258bd7676da"
    sha256 cellar: :any_skip_relocation, ventura:       "505ecb1a25b1532e4c4f164e4be67e64ce66380de9502dbeda2ff258bd7676da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf6a450e3b732548bbe89f23bda6494acbf4bba8b33736de9698193830e39b97"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "f-droid.org/repo", shell_output("#{bin}/fdroidcl update")

    list = <<~EOS
      Connectivity
      Development
      Games
      Graphics
      Internet
      Money
      Multimedia
      Navigation
      Phone & SMS
      Reading
      Science & Education
      Security
      Sports & Health
      System
      Theming
      Time
      Writing
    EOS
    assert_equal list, shell_output("#{bin}/fdroidcl list categories")
    assert_match version.to_s, shell_output("#{bin}/fdroidcl version")
  end
end
