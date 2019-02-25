class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      :tag      => "v0.1.5389",
      :revision => "4379bab5169f609898214b717c313f9943fdbe41"

  bottle do
    cellar :any_skip_relocation
    sha256 "4bc9fabd3450a06f1b8579374819b963d8628eab639782f2e2d0280e9ab3268d" => :mojave
    sha256 "e7fc632bc38193b425ed8ae5b44ed64eac6bb1444dedd33399ab162bca16598a" => :high_sierra
    sha256 "0aa8a7ae8a436796a3006804c764deb705aa85e6c9f577614599804e23101ffa" => :sierra
  end

  depends_on "go" => :build

  resource "packr" do
    "https://github.com/gobuffalo/packr/releases/download/v2.0.1/packr_2.0.1_darwin_amd64.tar.gz"
    # Source: https://github.com/gobuffalo/packr/releases/download/v2.0.1/checksums.txt
    "0347a77997471535ea5cddaabc962aba16a374582ec75af7c901c8d0877aef69"
  end

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "on"

    dir = buildpath/"src/github.com/CircleCI-Public/circleci-cli"
    dir.install buildpath.children

    cd dir do
      # TODO: figure out the right syntax for this (change pycrypto to packr)
      # resource("pycrypto").stage { system "python", *Language::Python.setup_install_args(libexec/"vendor") }
      system "make", "pack"
      commit = Utils.popen_read("git rev-parse --short HEAD").chomp
      ldflags = %W[
        -s -w
        -X github.com/CircleCI-Public/circleci-cli/cmd.PackageManager=homebrew
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
    # assert update is not included in output of help meaning it was not included in the build
    assert_match "update      This command is unavailable on your platform", shell_output("#{bin}/circleci help")
    assert_match "`update` is not available because this tool was installed using `homebrew`.", shell_output("#{bin}/circleci update")
  end
end
