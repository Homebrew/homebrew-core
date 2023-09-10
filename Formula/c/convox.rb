class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.13.5.tar.gz"
  sha256 "4ba5afe6e39d3988d1eac12e419766cf26bcd5ae6f4474ce1c7c549e91e95ebf"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "61777a640583d93fba2233c1219126653b4b7697b3e87ac88b0c21b6cd6670ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a26236485319036eac19cd76006023f1f5f1d790d0127e328fac3c7145d29643"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "62d680f1cec7092097fa88f117c14b3aeb999c92a25396eefab9943a7267cbb2"
    sha256 cellar: :any_skip_relocation, ventura:        "612095e66f2e4e4e7392b70c30a5967973bec1602cfae63022411901ad6d3963"
    sha256 cellar: :any_skip_relocation, monterey:       "1e97dc4924c9e71763cca50b579334ac8db3d511111f53390badf550aad864ba"
    sha256 cellar: :any_skip_relocation, big_sur:        "fa769b9c46454de59d6c35736fb3b757755eba211a1a80fbba7d682a04d44fb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "290c3f45f88061a66e602e66dd28d39a4e8f5ad4d9dc760539824e58c6a85d3a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", "-mod=readonly", *std_go_args(ldflags: ldflags), "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end
