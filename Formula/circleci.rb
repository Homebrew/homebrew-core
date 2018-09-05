class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      :tag => "v0.1.2045",
      :revision => "8f1ad369dfec21b9b127554dc644f2f488938c06"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "86e001dcfa6aae67bcf250520f2c33f6d6c03753c0ccfb31a829ff978f073e27" => :mojave
    sha256 "ff423161a4c9dd53f40a120738b78cd1a089b8a473bb3177f1813e3884b744cc" => :high_sierra
    sha256 "fbf5048c2b24a7ad9fba95ecb98761cb55b379c8d41e42e0a253cc3666f74c59" => :sierra
    sha256 "099639633d480435e7b2676f94974a65efa421352c7da32d4c3fb907f4d9141c" => :el_capitan
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
    # assert script fails for missing docker (docker not on homebrew CI servers)
    output = shell_output("#{bin}/circleci build 2>&1", 255)
    assert_match "failed to pull latest docker image", output
  end
end
