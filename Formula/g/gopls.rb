class Gopls < Formula
  desc "Language server for the Go language"
  homepage "https://github.com/golang/tools/tree/master/gopls"
  url "https://github.com/golang/tools/archive/refs/tags/gopls/v0.15.2.tar.gz"
  sha256 "cf5b8246b36967eb8fbbed518ea941110cc6bbcc7f42a44bc5a4fe0d7ee61652"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(%r{^(?:gopls/)?v?(\d+(?:\.\d+)+)$}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "02254e5279d297e24ed9eee250351442cb210f08f2260628d0ba434f8b0f0809"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "851f2c9dec096c7daf5938a054a1ca8a978475529d7dcd9d26f61e83862b756f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4ef772b62a5ebd56a4eb823a9afc42a17cd44f15d13db4075d7c9eda88999fb"
    sha256 cellar: :any_skip_relocation, sonoma:         "97b18cbe372c9f2e3dd103c0e518d17725ac798da9556e2d072ad1834b36497d"
    sha256 cellar: :any_skip_relocation, ventura:        "65aa09d315e84bd80e1f439373f2d70c351e03a2f926f89bde786a7b6951fe03"
    sha256 cellar: :any_skip_relocation, monterey:       "0e20bffa8c8849d7864077af9704d6523e5d58ecc49fc7ef958795bb16797342"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a28f6b4ad18a2a6e04ec579d510b9435135633e2fb723da21bfc0c339982f45a"
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
