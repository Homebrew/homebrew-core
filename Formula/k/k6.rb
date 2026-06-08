class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https://k6.io"
  url "https://github.com/grafana/k6/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "144619fb25dcddc3fad8457497f0ffd8e3f9e19005303a752d4401ec2250036a"
  license "AGPL-3.0-or-later"
  head "https://github.com/grafana/k6.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "21ac09525175308de1fcfc06e2a2c3620d35b5faf16a424bc55416a4392759c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd1fedfc0bd116313828c1d74b3be1bd0bafb4b7a6bd6b03b30e781400f63986"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1063d7b5d2be4b13c17375e689095d946437b4456774ddf50410a804e0dbe169"
    sha256 cellar: :any_skip_relocation, sonoma:        "c14b015469388dee03aa0cd44d06ace7ead9b2f4fc3e680bbb70528aadeb9278"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd27e20d7beafbc2d9bc23306ce5dd6e3bfa2fa5a1c7fa2a70851da7d4606f53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5068ea0283ef9a3f6cce6e14bc5e0922e92383541a931b87d080032d8f94893e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"k6", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"whatever.js").write <<~JS
      export default function() {
        console.log("whatever");
      }
    JS

    assert_match "whatever", shell_output("#{bin}/k6 run whatever.js 2>&1")

    assert_match version.to_s, shell_output("#{bin}/k6 version")
  end
end
