class Preevy < Formula
  desc "Quickly deploy preview environments to the cloud"
  homepage "https://preevy.dev/"
  url "https://registry.npmjs.org/preevy/-/preevy-0.0.67.tgz"
  sha256 "7f07237d5d5112250b7ee8a3f2ee1af3df1ef2f6cfa984040aef2e2a884b30e7"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_tahoe:   "0ecfe50451d749ef862d67a719df6877d1bc707ae3a4254fabd37635ac0581a7"
    sha256                               arm64_sequoia: "13f0d0eb46761af3cfad9914316e60ff0a57b9c66de29c6ff5a36c075a126c5e"
    sha256                               arm64_sonoma:  "2a80857e600f0e08aae2cdaa68220e3ce26a5e9f5d282cb5368d934944ed8355"
    sha256                               arm64_ventura: "b3d2111934d904a21e073113ffb2a53da7d8784907cf06bd92a64d24be3e6399"
    sha256                               sonoma:        "a511ef38d0a334bb9eb9ab49781d75974a33d08074870a153339087e9e950428"
    sha256                               ventura:       "92c7b3fe2e0fb816a63b6b0c2feb8446be062eec443dbb6a5416b4b9937f056a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e99bec653db6fb724499c73557bfde947aad0f58d6e1b0698ec173803efa175"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a58855d54fa97236e0fad7088c96a745ac2ef33b6f3a9caf03bd6cfd08ebaa1"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/preevy --version")

    output = shell_output("#{bin}/preevy ls 2>&1", 2)
    assert_match "Error: Profile not initialized", output
  end
end
