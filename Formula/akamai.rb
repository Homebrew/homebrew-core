class Akamai < Formula
  desc "CLI toolkit for working with Akamai's APIs"
  homepage "https://github.com/akamai/cli"
  url "https://github.com/akamai/cli/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "ffd4954782a3e524b91d743a6f65f7b8514872a2c059009af638571ec7a89fe7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, monterey:     "356f7d8cbd9c999795ebb918fa004368596e1e9992741e3a46d7c0243cf0f16a"
    sha256 cellar: :any_skip_relocation, big_sur:      "67beb33a60760f11cdad4e30c2a45ff85ad63de081677b5d31011692e87dd2ac"
    sha256 cellar: :any_skip_relocation, catalina:     "2a0d8a62bf53a295697b9c9e5e6ef137507b55ffad07a6f25100a2e6134dd4a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d68de8020c21317cae498f11a875cb3b19ea9b1e20355940071627caeb43239f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-tags", "noautoupgrade nofirstrun", *std_go_args, "cli/main.go"
  end

  test do
    assert_match "Purge", pipe_output("#{bin}/akamai install --force purge", "n")
  end
end
