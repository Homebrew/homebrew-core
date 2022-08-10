class Gopls < Formula
  desc "Language server for the Go language"
  homepage "https://github.com/golang/tools/tree/master/gopls"
  url "https://github.com/golang/tools/archive/gopls/v0.9.2.tar.gz"
  sha256 "b71b3143c62193ea7973bbabb47c7cccbf9ad864ce2f6e0b54b005671050d515"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{(?:content|href)=.*?/tag/(?:gopls%2F)v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aeb6c0399f46251f71f35ccf2c03c4aa7054a11fb8680475a7b30d940b9c8267"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "99f0cba834a4cd92ee990b18ea1ff09c4a385a7f770b36a7db95f277b970d7c0"
    sha256 cellar: :any_skip_relocation, monterey:       "9792a14d46dde65a8b92ba30a7c06adf3e05ec9ac85f28de7b19fd90204bd9db"
    sha256 cellar: :any_skip_relocation, big_sur:        "96362c163dd164a1a3e188f5792f1cd30ef7fec4ab0eec52e9e9077c680d60b8"
    sha256 cellar: :any_skip_relocation, catalina:       "41973a7906d4bf4b40c62b10af7ef2e09cc334ecad4432de9705b306c1b05655"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd00cffb45a3cfef16c3d163f92d234f0857b951f2b1f616a2cbe7d28f342ce2"
  end

  depends_on "go" => :build

  def install
    cd "gopls" do
      system "go", "build", *std_go_args
    end
  end

  test do
    output = shell_output("#{bin}/gopls api-json")
    output = JSON.parse(output)

    assert_equal "gopls.add_dependency", output["Commands"][0]["Command"]
    assert_equal "buildFlags", output["Options"]["User"][0]["Name"]
  end
end
