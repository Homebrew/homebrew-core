class Dbxcli < Formula
  desc "Command-line tool for Dropbox users and team admins"
  homepage "https://github.com/dropbox/dbxcli"
  url "https://github.com/dropbox/dbxcli/archive/refs/tags/v3.7.2.tar.gz"
  sha256 "948ce331d62b2bcd7de8e5df7b951507ecc15920e172942d5ae7ec995417da13"
  license "Apache-2.0"
  head "https://github.com/dropbox/dbxcli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4129c3ae4001064d40ef29dab94737af0979d8dd2d01ab583408f7cb2cc4eb88"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4129c3ae4001064d40ef29dab94737af0979d8dd2d01ab583408f7cb2cc4eb88"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4129c3ae4001064d40ef29dab94737af0979d8dd2d01ab583408f7cb2cc4eb88"
    sha256 cellar: :any_skip_relocation, sonoma:        "71a82ca92909052c768e0520479883ae1bb65774f67dbb98b9f80a991409f4ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5ec87ca99f50e172bee2480ecdebf5bb9b7dc73bc3abb48802352bfcea035e4"
    sha256 cellar: :any,                 x86_64_linux:  "5e5c2ad779dbbad081a3630445ec41b3a6dac2bff01b1bbdb82c26ca11a7ef88"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")

    generate_completions_from_executable(bin/"dbxcli", "completion")
  end

  test do
    ENV["DBXCLI_AUTH_FILE"] = testpath/"missing-auth.json"
    output = shell_output("#{bin}/dbxcli ls 2>&1", 2)
    assert_match "no saved Dropbox credentials", output
  end
end
