class GoAir < Formula
  desc "Live reload for Go apps"
  homepage "https://github.com/air-verse/air"
  url "https://github.com/air-verse/air/archive/refs/tags/v1.65.3.tar.gz"
  sha256 "35fde02b7cdc39cf3a53e97187e894c443dcdeb1475bc654250cbb5c22428a80"
  license "GPL-3.0-or-later"
  head "https://github.com/air-verse/air.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "58c5e2c063efaba2528b8fdd2fd55e64f9ebe1d6d1bb33cda74bd52f4f858921"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58c5e2c063efaba2528b8fdd2fd55e64f9ebe1d6d1bb33cda74bd52f4f858921"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "58c5e2c063efaba2528b8fdd2fd55e64f9ebe1d6d1bb33cda74bd52f4f858921"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c4aeafe956558b6588147375a5950b95cfd7b60b0bee2144510a81a7192410c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7acbcdc059f3781519f626cb02ccfc296fac18c76956d098d80e289be77e70e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8021062a49ecc4953dc85f806af9618f84c9446db0c6310d9269e26534793ea"
  end

  depends_on "go"

  conflicts_with "air", because: "both install binaries with the same name"

  def install
    ldflags = %W[
      -s -w
      -X main.BuildTimestamp=#{time.iso8601}
      -X main.airVersion=v#{version}
      -X main.goVersion=#{Formula["go"].version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags.join(" "), output: bin/"air")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/air -v 2>&1")
    (testpath/"air-test").mkpath
    cd testpath/"air-test" do
      system "go", "mod", "init", "air-test"
      system bin/"air", "init"
    end
    assert_path_exists testpath/"air-test/.air.toml"
  end
end
