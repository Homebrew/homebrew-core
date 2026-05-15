class Jaguar < Formula
  desc "Live reloading for your ESP32"
  homepage "https://toitlang.org/"
  url "https://github.com/toitlang/jaguar/archive/refs/tags/v1.65.0.tar.gz"
  sha256 "51e3e62f88191b2e0202205911065558896f1c24ae849d7f3b6efdfdf339d950"
  license "MIT"
  head "https://github.com/toitlang/jaguar.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "87e83e0f8be0128f23444f2a62ca99a8e3d15d35b110e19108a15715454c0514"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87e83e0f8be0128f23444f2a62ca99a8e3d15d35b110e19108a15715454c0514"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87e83e0f8be0128f23444f2a62ca99a8e3d15d35b110e19108a15715454c0514"
    sha256 cellar: :any_skip_relocation, sonoma:        "19ffa716cb13ba76dddf76080ad6b54b9daeb0f2de93dc7c244fdae547b686e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a120b4244c8d225beaae804fe708a6f24efd30f57e300462b24eb068e503cee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7a29b80ba4ad10cfca52cce1ef009ca74e5e0c7179b222469fd95a1aa21a1c2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.buildDate=#{time.iso8601}
      -X main.buildMode=release
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"jag"), "./cmd/jag"

    generate_completions_from_executable(bin/"jag", shell_parameter_format: :cobra)
  end

  test do
    assert_match "Version:\t v#{version}", shell_output("#{bin}/jag --no-analytics version 2>&1")

    (testpath/"hello.toit").write <<~TOIT
      main:
        print "Hello, world!"
    TOIT

    # Cannot do anything without installing SDK to $HOME/.cache/jaguar/
    assert_match "You must setup the SDK", shell_output("#{bin}/jag run #{testpath}/hello.toit 2>&1", 1)
  end
end
