class Govc < Formula
  desc "Command-line tool for VMware vSphere"
  homepage "https://github.com/vmware/govmomi/tree/master/govc"
  url "https://github.com/vmware/govmomi/archive/v0.31.0.tar.gz"
  sha256 "6756f446dfc35269de6bdbc578ebc768e8894304708c6c3289fc5a3f2a5e310a"
  license "Apache-2.0"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7d28f2edeb5c3aec0f0f1dbdfeff877f9fc01ece64b772955733792e1b1eb65d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1385cf89bc24847f3bdd6f246a7b0371ad5cad6017b8dd2d48d4d2d9b2cc3b4b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8944209ae551602d4be02a5810b4218dc789879362c8ac038b3d1bca4293c3a8"
    sha256 cellar: :any_skip_relocation, sonoma:         "40620fc54d98dbde4fb693aef47ee0fed615067105bb755ac62cf8cd17982881"
    sha256 cellar: :any_skip_relocation, ventura:        "d57f888f15ca6903cc720c27a66f17e043902c935881ef092ce90e9a709fd970"
    sha256 cellar: :any_skip_relocation, monterey:       "9cf061de8132288ae504f47952a5e35797d8d53d47b40c1e0ba0813119a3aff8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0c7b359a225d708881ea370330d3be63394379197a0443edff84fdd41e9829d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "#{bin}/#{name}", "./#{name}"
  end

  test do
    assert_match "GOVC_URL=foo", shell_output("#{bin}/#{name} env -u=foo")
  end
end
