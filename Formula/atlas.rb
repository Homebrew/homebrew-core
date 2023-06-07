class Atlas < Formula
  desc "Database toolkit"
  homepage "https://atlasgo.io/"
  url "https://github.com/ariga/atlas/archive/v0.12.0.tar.gz"
  sha256 "739bcf579be963e02df59061f41e2a98e00b48895bb2a35d98b10ec67499d5fa"
  license "Apache-2.0"
  head "https://github.com/ariga/atlas.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ba2dd1826adf6932994c258b01dd0c78bb8964d366c8b0e5cedb83254f32dd8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dad8a66a0e83c05141187e5e571e269276bb2e74b1549f3f026e58924c54a612"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b95a4f228309fe133605dacd93fdc55ac6f8fd82dc5e3b333a02861689fc24d8"
    sha256 cellar: :any_skip_relocation, ventura:        "d9f5e5eb51c54eeb98e6d0138533a0945272fc423d10e435a40d8af5ed381ef6"
    sha256 cellar: :any_skip_relocation, monterey:       "bbb2397f7baab8f9b28bb515eb4dd7ad1f6ee8be29404d63608e568706b1aa63"
    sha256 cellar: :any_skip_relocation, big_sur:        "5a4a13d33157fda30681c7997e07efee99b6111bdd10ab1b17a4041ffa53b854"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13b970e94b3fcca8005708e16caae376290860b8be281aeeb62f2bfd9e93bf75"
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
