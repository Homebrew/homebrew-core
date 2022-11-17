class Akamai < Formula
  desc "CLI toolkit for working with Akamai's APIs"
  homepage "https://github.com/akamai/cli"
  url "https://github.com/akamai/cli/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "33e4e41ea3697bf84d99354f993edab5ef45a160f92f8e5da094cb12c624980c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c9bb02d83051f8efa16b4c8242acc2ab2de133f063cc2b824cc40c9cd30f1a7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0b2a860ee65e6e249894d19f0a03b423f4b0e774105066f5836c6449b53131a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b06521e34515aecdb81e1dad94b442ed5e9f1062f2ba320d1bf0e0079d2ea185"
    sha256 cellar: :any_skip_relocation, ventura:        "6d844229eec66419b51eee9bed485bb546174d6ad469bafbf261324c7b4ac29c"
    sha256 cellar: :any_skip_relocation, monterey:       "3f3091301abecbdddf70e049839b142f15b028aa3847948d660499a4cf88f33f"
    sha256 cellar: :any_skip_relocation, big_sur:        "dd39fdf7552c28df9cccc57e8d607705ee0f507c2562c6fe1b38e82042e72a98"
    sha256 cellar: :any_skip_relocation, catalina:       "ce6876e71487eda4afd75fc8b5c6ffcad506f9c47258aaa7522bd94b2228f3e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2b41487911bfb7001c932fa5c94ceda01818c57bc350b86999f7f64791a62f2"
  end

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", "-tags", "noautoupgrade nofirstrun", *std_go_args, "cli/main.go"
  end

  test do
    assert_match "diagnostics", shell_output("#{bin}/akamai install diagnostics")
    system bin/"akamai", "uninstall", "diagnostics"
  end
end
