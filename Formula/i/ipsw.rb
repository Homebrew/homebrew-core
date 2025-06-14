class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.613.tar.gz"
  sha256 "ce2ce277f1cc24157241daaf0a7ddd8cab4d3b49d74f456730203bc7d4c5e693"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee69881f0dd83145a236ba5355a1dd6e7a8f0e1fe9abbbc43e36555b71fc18bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "01e6d83ca0287d0cde56dd0ed14235b45941e21b308c63e6faa07f3cc0df9778"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "accf507beb0d342e0f1a9dd8c5a7b3869f31d7e0880a14a69a13725a59b7ffeb"
    sha256 cellar: :any_skip_relocation, sonoma:        "8aa6916477ae4b36ad3965c31cf8cd56a6e2567a97d43531499202e680e20d05"
    sha256 cellar: :any_skip_relocation, ventura:       "1497e48687bc349b5b00c30b849a8b1a8c7ce122fe7d9537c90226f7905f2972"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "46a3671508f779eac54dcb78483691de397a85e0990d9eda04b1f9b93e528fe2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc6fece78f4db75e6a61c463a1bc29d59f99ce93ba57a1272121bd51acdef4e8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppVersion=#{version}
      -X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppBuildCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/ipsw"
    generate_completions_from_executable(bin/"ipsw", "completion")
  end

  test do
    assert_match version.to_s, shell_output(bin/"ipsw version")

    assert_match "MacFamily20,1", shell_output(bin/"ipsw device-list")
  end
end
