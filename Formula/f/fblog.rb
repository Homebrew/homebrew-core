class Fblog < Formula
  desc "Small command-line JSON log viewer"
  homepage "https://github.com/brocode/fblog"
  url "https://github.com/brocode/fblog/archive/refs/tags/v4.13.1.tar.gz"
  sha256 "0212dd590cdcb4794a44ea79535ba298c1e971bb344a248fb84528777b0998f1"
  license "WTFPL"
  head "https://github.com/brocode/fblog.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73867f81b00c8e28c9671b83098bae1aa46d794cd55d4f30ee65d58c1165edd3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a46b49a09c73bf9c6bb4a24854a2ed5396dbcbbbe26f606b20bac77399376425"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "159918297156f46b6f13fe16032a0f3b2e69836fdf00a063dddcf5835f522c90"
    sha256 cellar: :any_skip_relocation, sonoma:        "9648a49e189ceb4a800f5ced71d164cc92b177116d10b507c68454af9206f586"
    sha256 cellar: :any_skip_relocation, ventura:       "6311327a97de4601901eeeb25a511a2a4fbf9a9b86618e155972df34fc78399b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ad7f48d3aecc6a1b2d82c2cf719fc1b138338319598f5461973e90c3c21ee8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37f02dbfb49c62b0d0dbda280d6262f503cb3a45fcdb327e6323858fd75f53cf"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"fblog", "--generate-completions")

    # Install a sample log for testing purposes
    pkgshare.install "sample.json.log"
  end

  test do
    output = shell_output("#{bin}/fblog #{pkgshare/"sample.json.log"}")

    assert_match "Trust key rsa-43fe6c3d-6242-11e7-8b0c-02420a000007 found in cache", output
    assert_match "Content-Type set both in header", output
    assert_match "Request: Success", output
  end
end
