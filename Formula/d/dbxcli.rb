class Dbxcli < Formula
  desc "Command-line tool for Dropbox users and team admins"
  homepage "https://github.com/dropbox/dbxcli"
  url "https://github.com/dropbox/dbxcli/archive/refs/tags/v3.6.1.tar.gz"
  sha256 "464f8bb13042edf1df92cca1f0f0c96e412c84f04093ed20ab9d4b49ee7ed9b5"
  license "Apache-2.0"
  head "https://github.com/dropbox/dbxcli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2cc3b7c67a15b438a3387065ae92ab00f47993f091344fd09a003835f977cb8a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32028d9cdd01778f58bd3e30db15062c0941f18f9b8c134f3fae17ddcf624346"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02f0aba4d03d121ccf06bb5d719cf18fd35aaa0d301c9716cc3ccb4e16196a4d"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a667f744eb373e58f2cc30b61fdd1782a1c09f924c458b8796d6e868cf74830"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "efdb631fe38ec0020707648e13b316d0eb31d54eda8a1b3c18aa8ca1e3fd2c10"
    sha256 cellar: :any,                 x86_64_linux:  "e1ff45b9c8fff04ba8c14d14c85f2f2c775b744c7aab562088690937c2a28ccf"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    generate_completions_from_executable(bin/"dbxcli", "completion")
  end

  test do
    ENV["DBXCLI_AUTH_FILE"] = testpath/"missing-auth.json"
    output = shell_output("#{bin}/dbxcli ls 2>&1", 2)
    assert_match "no saved Dropbox credentials", output
  end
end
