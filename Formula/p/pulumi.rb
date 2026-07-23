class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://www.pulumi.com/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.253.0",
      revision: "94536e530d770753b42087931c3e5c0b3c5a51b7"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "674984f4c40d7634380fbf76babf467da26df1664253e1be0ed55d0653627c7a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8fcd266fea80ee742f7e5cda22a15a638821e661a67af83e51b74cd204b78a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb207dd447910bc56a99068720764570e5e4b61b9d2341e7d70596524d3b7eb8"
    sha256 cellar: :any_skip_relocation, sonoma:        "91a57c6582ba483a6b4db68a8d4f7111d6367448ff998408a6a8252c4b0e855c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78c00719415bf96dd0e052ecef37b97da21a7583bf0cfcb6aa01ac84bab25a67"
    sha256 cellar: :any,                 x86_64_linux:  "dd463514e388cd7af694e6a80e20d7eb9d3fa674b5e9423088ad617d97a92de2"
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
