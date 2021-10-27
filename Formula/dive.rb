class Dive < Formula
  desc "Tool for exploring each layer in a docker image"
  homepage "https://github.com/wagoodman/dive"
  url "https://github.com/wagoodman/dive.git",
      tag:      "v0.10.0",
      revision: "64880972b0726ec2ff2b005b0cc97801067c1bb5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "301a650dbfacbef1d53f94a76918bccab8de782b2e45fb747b1dceffadb4ee19"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "734a6756d2f43b3d0e91d71b9e6ef024e6a031e5d7c3ab6a44c49c3bbb8c8655"
    sha256 cellar: :any_skip_relocation, monterey:       "f533a63cbe72e587cf2e81d0ecf4df06b553a3b4458e6898407aa559b93b45d9"
    sha256 cellar: :any_skip_relocation, big_sur:        "4fdeb80d1d57527ef5887c98a5db2235e73edb7b3d0fe32d42f0cfcf0ea49780"
    sha256 cellar: :any_skip_relocation, catalina:       "8c17b54b9370b6bc8d36dde60d42b71a7ef0fc3d700bd67893fe04c8ec1f69f9"
    sha256 cellar: :any_skip_relocation, mojave:         "3e67c19a68dc97ba2b66e57886923b5abee437c74e83a76e289a1fc491c0416f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "795372731d4e6cd97f76b98f84c9c03878f18277be95f3f94033990f05abc6ba"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "gpgme" => :build
    depends_on "pkg-config" => :build
    depends_on "device-mapper"
  end

  def install
    system "go", "build", "-ldflags", "-s -w -X main.version=#{version}", "-trimpath", "-o", bin/"dive"
    prefix.install_metafiles
  end

  test do
    (testpath/"Dockerfile").write <<~EOS
      FROM alpine
      ENV test=homebrew-core
      RUN echo "hello"
    EOS

    assert_match "dive #{version}", shell_output("#{bin}/dive version")
    assert_match "Building image", shell_output("CI=true #{bin}/dive build .", 1)
  end
end
