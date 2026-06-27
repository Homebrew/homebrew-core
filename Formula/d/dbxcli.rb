class Dbxcli < Formula
  desc "Command-line tool for Dropbox users and team admins"
  homepage "https://github.com/dropbox/dbxcli"
  url "https://github.com/dropbox/dbxcli/archive/refs/tags/v3.5.0.tar.gz"
  sha256 "f74f71ab68068ce53147119194b81ea5ece1ea8310e0181d161e77452f2a2138"
  license "Apache-2.0"
  head "https://github.com/dropbox/dbxcli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f0f8ed0acd3ac6d46028e0fc368418a74be6b91e74dd2850b2e70b63f57c647f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0f8ed0acd3ac6d46028e0fc368418a74be6b91e74dd2850b2e70b63f57c647f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0f8ed0acd3ac6d46028e0fc368418a74be6b91e74dd2850b2e70b63f57c647f"
    sha256 cellar: :any_skip_relocation, sonoma:        "9468d87b0dbb5840051378eccebfc7b999873eeecab6e86178a134e20ac42e60"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7bd4da616ad9afd7aa04d65813527b8c12be53ff4f5e846188defa70b4f8705d"
    sha256 cellar: :any,                 x86_64_linux:  "f7ab5a0d2dd388b8714e5a3dabcad00514403193ac7a48f4e3b70801ba7c9213"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    generate_completions_from_executable(bin/"dbxcli", "completion")
  end

  test do
    ENV["DBXCLI_AUTH_FILE"] = testpath/"missing-auth.json"
    output = shell_output("#{bin}/dbxcli ls 2>&1", 1)
    assert_match "no saved Dropbox credentials", output
  end
end
