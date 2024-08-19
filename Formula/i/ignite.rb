class Ignite < Formula
  desc "Build, launch, and maintain any crypto application with Ignite CLI"
  homepage "https://github.com/ignite/cli"
  url "https://github.com/ignite/cli/archive/refs/tags/v28.5.1.tar.gz"
  sha256 "6e8e9a5f596346c6824adcab73691db28addcee5bb015ea04e8f121eb508e7e7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "23b6fe61222d768af4b385bd73a0a317d0c2836784a79fc707694726a3762357"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d45e9e586ace5df465adae98d500d636c0d7dd0668178fb1a5f0b99285c02127"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3339d46c3bf97b92cabaca1f97e6dec20dcb16dd1c55971575b23c144bfae3cf"
    sha256 cellar: :any_skip_relocation, sonoma:         "bd9a256c799152f35562aa0fdf5c0545af0b7138b3bc073a1cf9d9b316b2c815"
    sha256 cellar: :any_skip_relocation, ventura:        "6300033dccd952a9e0e821788b45e8e2cd1b584f2757bfc3e23d5fe82bd0b2c5"
    sha256 cellar: :any_skip_relocation, monterey:       "4715fbed23a01d8f2bd082b3ed8fee77dba5863b1e555a227be1cb97156366b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ccc5a6f6477da7eaf31f05443213204a23bcde7b2814330a27ca89188994d686"
  end

  depends_on "go"
  depends_on "node"

  def install
    system "go", "build", "-mod=readonly", *std_go_args(output: bin/"ignite"), "./ignite/cmd/ignite"
  end

  test do
    ENV["DO_NOT_TRACK"] = "1"
    system bin/"ignite", "s", "chain", "mars"
    sleep 2
    assert_predicate testpath/"mars/go.mod", :exist?
  end
end
