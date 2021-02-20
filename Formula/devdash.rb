class Devdash < Formula
  desc "Highly Configurable Terminal Dashboard for Developers"
  homepage "https://thedevdash.com"
  url "https://github.com/Phantas0s/devdash/archive/v0.4.1.tar.gz"
  sha256 "801a4c9b316834589b472e87d2ed16a093b2e6031cb2724668c5ea61b28813c8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c6dc9ae5887a01f241dc9e79866dce93f985f53ae147c99af5a0c6a7159513bf"
    sha256 cellar: :any_skip_relocation, big_sur:       "5e62dd8b464ba2ade11434f471dc51aaea30b1c799ef0aa4096c5ccabe534508"
    sha256 cellar: :any_skip_relocation, catalina:      "011dfa77fabb7a61086a383e8af8dad8239d29732fa0f5a0737c9787e214cdf1"
    sha256 cellar: :any_skip_relocation, mojave:        "17e84eaa344dd543c936f140f08515918d00a847a675bd64eb9d4e256f8b4298"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    system bin/"devdash", "-h"
  end
end
