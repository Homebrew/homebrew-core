class Ocm < Formula
  desc "CLI for the Red Hat OpenShift Cluster Manager"
  homepage "https://www.openshift.com/"
  url "https://github.com/openshift-online/ocm-cli/archive/refs/tags/v0.1.76.tar.gz"
  sha256 "4b5e52911c29f9b374921b93e75ad5b69c9be326c6f67f32854403f2539b754c"
  license "Apache-2.0"
  head "https://github.com/openshift-online/ocm-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cdeb4336aa122dba5a19915e3ed09c904de5d54af87ef2990d93703489c431d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0e1feffd38e1ce22ba5c541a33ba74d17d8e25d6a8a27b517380f55e9fb4205"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1ce217e265d07a617afb93111e33c3f44cc02cdbf5b652e5d71f836f58b3c9a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "81ff1c7d58ff0aadeda40694d6a81627081e61e627446fa168869fdb46a7468b"
    sha256 cellar: :any_skip_relocation, ventura:       "18ee9ea7cb98041d33998d00333039fd9407bf64c449ebbfe5e3ca964c9163ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb11a05345b5b329eebb63956ebc19461eea8d611a787f810b399fa139fe566b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w"
    system "go", "build", *std_go_args(ldflags:), "./cmd/ocm"
    generate_completions_from_executable(bin/"ocm", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ocm version")

    # Test that the config can be created and configuration set in it
    ENV["OCM_CONFIG"] = testpath/"ocm.json"
    system bin/"ocm", "config", "set", "pager", "less"
    config_json = JSON.parse(File.read(ENV["OCM_CONFIG"]))
    assert_equal "less", config_json["pager"]
  end
end
