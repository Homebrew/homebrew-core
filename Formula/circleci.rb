class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      :tag => "v0.1.3139",
      :revision => "2743216fe2fb5cfedc28373aa8df8851c715d1eb"

  bottle do
    cellar :any_skip_relocation
    sha256 "03fd474669f49ceb137d54012832ec7cc78fe892f88285e9fcf768add42445f8" => :mojave
    sha256 "f61e1828b54226b83500160550e33fd6f8d19a0bf7fed0efee1d27990b5904a5" => :high_sierra
    sha256 "1190599eeb999cbafaa1de98a5c6fbcf9786418a677e6ba4b9556b2b5024d6b0" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/CircleCI-Public/circleci-cli"
    dir.install buildpath.children

    cd dir do
      commit = Utils.popen_read("git rev-parse --short HEAD").chomp
      ldflags = %W[
        -s -w
        -X github.com/CircleCI-Public/circleci-cli/version.Version=#{version}
        -X github.com/CircleCI-Public/circleci-cli/version.Commit=#{commit}
      ]
      system "go", "build", "-ldflags", ldflags.join(" "),
             "-o", bin/"circleci"
      prefix.install_metafiles
    end
  end

  test do
    # assert basic script execution
    assert_match /#{version}\+.{7}/, shell_output("#{bin}/circleci version").strip
    # assert script fails because 2.1 config is not supported for local builds
    (testpath/".circleci.yml").write("{version: 2.1}")
    output = shell_output("#{bin}/circleci build -c #{testpath}/.circleci.yml 2>&1", 255)
    assert_match "Local builds do not support that version at this time", output
  end
end
