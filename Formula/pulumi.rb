class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.47.0",
      revision: "ea386747e886db44c7e6a26ade916745a7cb8202"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "90aae4176e175f25798d76fc167951e9736edb6ca5754c70a8a9db35012dad64"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b82f0f95c8be5e5147572d18f1c2dd94723673307f0f01238ead9809f68d4d3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2210e099cd9aee9a17eb9c35fafd3b18ec4470a41ffd1df1341b34f269a39e3f"
    sha256 cellar: :any_skip_relocation, ventura:        "cd0f77fee6ebb2ddaee23216251017eab631de7a8bcdf17ba149ae45c47bbbc0"
    sha256 cellar: :any_skip_relocation, monterey:       "0b43abb5d22eb011e7b8b4b080ea8974849a4fad24018b6cd922f64ec51c700e"
    sha256 cellar: :any_skip_relocation, big_sur:        "7341935a827f029a1169f998febdc8447ecb686a16590bc225482a0f0935bd33"
    sha256 cellar: :any_skip_relocation, catalina:       "31ca6ef970761e585582a5b3fab724768e71ba8f3a190a194524db9c83aa1b4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1b38fda4d121feeab822299de38102c61378a95bc4bbfb30f3d0e4796314d33"
  end

  depends_on "go" => :build

  def install
    cd "./sdk" do
      system "go", "mod", "download"
    end
    cd "./pkg" do
      system "go", "mod", "download"
    end

    system "make", "brew"

    bin.install Dir["#{ENV["GOPATH"]}/bin/pulumi*"]

    # Install shell completions
    generate_completions_from_executable(bin/"pulumi", "gen-completion")
  end

  test do
    ENV["PULUMI_ACCESS_TOKEN"] = "local://"
    ENV["PULUMI_TEMPLATE_PATH"] = testpath/"templates"
    system "#{bin}/pulumi", "new", "aws-typescript", "--generate-only",
                                                     "--force", "-y"
    assert_predicate testpath/"Pulumi.yaml", :exist?, "Project was not created"
  end
end
