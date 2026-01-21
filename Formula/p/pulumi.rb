class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.216.0",
      revision: "1be7c7455f17d72c1aa8b211f40306c1b9e5f173"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b28aa2de314bc58b567653f9085d555c364f668c5106901160006132e4d5bf3d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10ffef79b621be2cfc25c3b62c643d31129eacbba788c994d1128946c386c7d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aae6e65e5543d5878849d3445bdc8533c244c4f3be617c5d0ab92f9b70deb74a"
    sha256 cellar: :any_skip_relocation, sonoma:        "56bbd4f22e5e025cd48cfea66c77242c18806bc35d1f56bf83a86a05bb2ce401"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27a54e799b0568b824e28af7d7a8557bc61d3c1fdbbd749769485dff1ccaeebf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13e1415c4b23c4e6c6bd3e8ff393b95fc06661ce2d447f63dded01705569b307"
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
    ENV["PULUMI_HOME"] = testpath
    ENV["PULUMI_TEMPLATE_PATH"] = testpath/"templates"
    assert_match "Your new project is ready to go!",
                 shell_output("#{bin}/pulumi new aws-typescript --generate-only --force --yes")
  end
end
