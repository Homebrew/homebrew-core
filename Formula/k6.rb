class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https://k6.io"
  url "https://github.com/grafana/k6/archive/v0.43.1.tar.gz"
  sha256 "fa1c8257046ee22fe7896079b393b27e55af767e44a4489f8977a7755acf7c53"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a320dcb9181007462703d9c2438a2b98f77236df0ddc10f5c1c17b0594892a08"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "476560c9ff848f20f76d4f3990d7e60fa1fb73d0da145c35a9914efbcd592092"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cadbaa76037190bc7d628def4c8b16f76fbe50c8724c2b984963802dd0fa5957"
    sha256 cellar: :any_skip_relocation, ventura:        "3277f1a1cfea112c4493d5cb36f8579cf4a9ddcd9ceee24f0ed1bdde1f780f44"
    sha256 cellar: :any_skip_relocation, monterey:       "1971ffd3eb1e6d5676a459a1d300b9582cc0991407fb377d88aaec9cfb641ac5"
    sha256 cellar: :any_skip_relocation, big_sur:        "aedb6bcbbfa9b3d399e82aefead0abb4f7c6ad179d9d2c8b0a76a68c07001a63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7d2f96a1459031aca8a9bf954d5558e0b4b9e2aa216e270dd441127ba5549fc"
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
