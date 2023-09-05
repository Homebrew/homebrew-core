class Atlas < Formula
  desc "Database toolkit"
  homepage "https://atlasgo.io/"
  url "https://github.com/ariga/atlas/archive/v0.14.0.tar.gz"
  sha256 "43a1c770e4638d9b09ee61d9547aae848c24629693bced3c578228b26fef18b7"
  license "Apache-2.0"
  head "https://github.com/ariga/atlas.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6484a7c998b4552ced59ba8370c46ddea95a0c0698969144e75dc9c92e8ebef5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4a8a66ba0e16c56b287743813ec9d000297502bb8fbd28c45086824680728a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d22cfca2c5a50f2bf27d1e4c883ebec17edbafd7b0aa3f80669ce72342d65580"
    sha256 cellar: :any_skip_relocation, ventura:        "88cc86ae8d45668e4192f2d1ac7781208d1820ccb84fc3d67bd56fed1494d057"
    sha256 cellar: :any_skip_relocation, monterey:       "f07bfb36aa832dbe095d266e947e6ecc50781c7a42efcb0993a09fac2777ddee"
    sha256 cellar: :any_skip_relocation, big_sur:        "803351dffe325f34ef368734e4bad0e567bdd872d8c13ea45b9246e2dd373ee6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3323eb6c52eaa02901c0bb1f45b445a8f8e074471f77c42506c3b077111afd3a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X ariga.io/atlas/cmd/atlas/internal/cmdapi.version=v#{version}
    ]
    cd "./cmd/atlas" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    generate_completions_from_executable(bin/"atlas", "completion")
  end

  test do
    assert_match "Error: mysql: query system variables:",
      shell_output("#{bin}/atlas schema inspect -u \"mysql://user:pass@localhost:3306/dbname\" 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/atlas version")
  end
end
