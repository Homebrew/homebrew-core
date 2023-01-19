class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.52.1",
      revision: "dd1c7150e3daf4385b96ae5bc9c58b4787f9422e"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ecf293e29862673cf25dbd3e38bfcf97a21648b95e3003861c084e01ce46b927"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a2182bd3c986a647b9a8eef6aae0ee79f253856f76e9cfa8ba4c5ce5ac9e88c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6c23d8e58c0f187e2c6727ae7ac287eede7594c7c772d3e2e034ea944944a519"
    sha256 cellar: :any_skip_relocation, ventura:        "483701f5e58b104893f7c560c7efca3c8d1aaf45b993b67049de6ba6c15d857e"
    sha256 cellar: :any_skip_relocation, monterey:       "b98d1c39a687b6f62f8a9276951217d324f558bc8a625d03effc57f3ea0e6cc2"
    sha256 cellar: :any_skip_relocation, big_sur:        "b114edef2a4d8008082e65940407f31635d8415fa7baf2fa8fbc43346b5ee3d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d40c35d4a804c696d436e49c5d494e6abb9933c672dd66e3c25299a4d03e308e"
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
