class GoAir < Formula
  desc "Live reload for Go apps"
  homepage "https://github.com/air-verse/air"
  url "https://github.com/air-verse/air/archive/refs/tags/v1.66.1.tar.gz"
  sha256 "04433622eb513153f22e63d1240caa7e232c5c49655c9f724610b0f5cbbd9ef2"
  license "GPL-3.0-or-later"
  head "https://github.com/air-verse/air.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9c6ead80d95004c927f026e209d286bdeb439661c32a55bf22374b270fe20d6b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c6ead80d95004c927f026e209d286bdeb439661c32a55bf22374b270fe20d6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c6ead80d95004c927f026e209d286bdeb439661c32a55bf22374b270fe20d6b"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d2bde93871baab6661bdbe25e7510d3d62510342570d5036690792f15f4d89e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a726588e49a81eb71e24a56926d837375901fdee0c9d4ea36b4851c5bc6ec0f8"
    sha256 cellar: :any,                 x86_64_linux:  "7776a0dd29f47789e74b732335b5ca4bbffe2c56a987cafb74779402e6ac9359"
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
