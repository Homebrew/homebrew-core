class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.44.1",
      revision: "4ca146e5bc80d5cbe5ba6896a7f9eed2f2134898"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b3510a2575c41f03a4072dce25327d3c3c677ae288584125fd4da202408f0603"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fbcfd05040e1af5de9ac2b5b3319f7a21d1c3945d18399bb858a3467fee31607"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "38854a52760d5105422c4af9b4a6ad39bee813dd4aadadfe17f5003635b38fb8"
    sha256 cellar: :any_skip_relocation, monterey:       "00b91c0e341cb3d7a0f41b5233ff1844622e116e5830ccc7daf78aa47939d56e"
    sha256 cellar: :any_skip_relocation, big_sur:        "7052b1b6e950f17a9d4782e3fa05352d0c87df2feb1172b4b78d912d19162fb1"
    sha256 cellar: :any_skip_relocation, catalina:       "3f7f732fffac85767e58c36b824129d7b0df5d008acd2db409202fdfa3b8e165"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "358c44f456c882a434f41cb6e22890d98135180362e9604138a6c37ad7b43a57"
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
