class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https://k6.io"
  url "https://github.com/grafana/k6/archive/v0.47.0.tar.gz"
  sha256 "f65abbeeafda8122fc4859940f75d953edfe69505bb62d0285820de02e6497a0"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ad568d2427f3ca2c7a78370f10ce5e7cea41f662019caaf955b48120296c7716"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "deffcbb6a355cf48d53762ec341d5ea1fa3753db0e969e2fe44e527ce00c1e7c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7f5983c126cc355f75cbd462883292ab379231da6ba55b704916a7ee9fd967f"
    sha256 cellar: :any_skip_relocation, sonoma:         "d91b5a27734f90e24c032fa988275d3661a7611f70834ebb63afe4cee310cdd6"
    sha256 cellar: :any_skip_relocation, ventura:        "0be03462417fd28975c782f29f016ac1edcb29d6577f5ba664f9685f84ea0638"
    sha256 cellar: :any_skip_relocation, monterey:       "0fad02ca3ba7533eeaeff81390c1455a7a268aa1618ea84fea4fd1d05a2200b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c92bba94aa22c796a249527010e26b7ec563d938e380bd797980ba441bfe0c76"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"k6", "completion")
  end

  test do
    (testpath/"whatever.js").write <<~EOS
      export default function() {
        console.log("whatever");
      }
    EOS

    assert_match "whatever", shell_output("#{bin}/k6 run whatever.js 2>&1")
    assert_match version.to_s, shell_output("#{bin}/k6 version")
  end
end
