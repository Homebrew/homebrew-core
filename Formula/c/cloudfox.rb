class Cloudfox < Formula
  desc "Automating situational awareness for cloud penetration tests"
  homepage "https://github.com/BishopFox/cloudfox"
  url "https://github.com/BishopFox/cloudfox/archive/refs/tags/v1.14.2.tar.gz"
  sha256 "fd0873c5fddd9a8d80a786c002721d0dd320c745edaf742b094d720299e32cda"
  license "MIT"
  head "https://github.com/BishopFox/cloudfox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "d21d21f09b89df003ad0c23f9a423e1f0af2a0a153f83a62591f65251248192a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9e404f80ad32ce50c6d2348a5bc82ae7b9cc58a4da91f6e49f4b2bfb09b18f0f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ca2d8ffd718305bda6b5071cc256c387e780bd8c589d2c47d889232981703b40"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "036e21f57267904160bfe66f70d1d0a35063b6249ecde65b714b5ee5bf059b9e"
    sha256 cellar: :any_skip_relocation, sonoma:         "c4abe3653fb2b6bfac26f779ab02f200068ece0dff41dc57d7d913d3fe57a826"
    sha256 cellar: :any_skip_relocation, ventura:        "93de87af33a13c904a88ba1267d535776009fc6842958ad97c8bed59dd1e7c4a"
    sha256 cellar: :any_skip_relocation, monterey:       "cdc1bab4fcfc22c2db10941651d4162e15acc6b49360cc7bc15a8eb41f72c29a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb2daef3a55d9c0ec74618094508478c0f05d3e230372862fd26971a79de4e30"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"cloudfox", "completion")
  end

  test do
    ENV["AWS_ACCESS_KEY_ID"] = "test"
    ENV["AWS_SECRET_ACCESS_KEY"] = "test"

    output = shell_output("#{bin}/cloudfox aws principals 2>&1")
    assert_match "Could not get caller's identity", output

    assert_match version.to_s, shell_output("#{bin}/cloudfox --version")
  end
end
