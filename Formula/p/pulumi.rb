class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.177.0",
      revision: "448663485ab203421ff62542585f7f4565c65c3f"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "deb0894eb6625db2556b22b1b96464981b5a297d8726a4263b7cbe304ff2b8b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d45cae2d97556d953fa2e0e9c2a8ccf46c30d40f4cfb0de93ddb6c2ef92dc574"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a88bc4e93c2716d8173e0c8bc4c844efdda1f49aa40a0665e05dde4f48938a96"
    sha256 cellar: :any_skip_relocation, sonoma:        "d732f8c81fa0a7c0eca24e8289342541f6d4adc0a92b797f25967fc94b454a76"
    sha256 cellar: :any_skip_relocation, ventura:       "b0445f1bd39efb21631fd0578e02c3c6b9986d1883a3b18c64f9c7821d6ad33d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1dd54b93dea33f4636ed7ce12d57ef04c230178c5d9107a0dbff2a3710844e7"
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
    assert_match "invalid access token",
                 shell_output(bin/"pulumi new aws-typescript --generate-only --force --yes 2>&1", 255)
  end
end
