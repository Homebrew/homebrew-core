class Asciinema < Formula
  desc "Record and share terminal sessions"
  homepage "https://asciinema.org"
  url "https://github.com/asciinema/asciinema/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "f44feaa1bc150e7964635dc4714fd86089a968587fed81dccf860ee7b64617ca"
  license "GPL-3.0-only"
  head "https://github.com/asciinema/asciinema.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77ab4d19608140cac9798c128b0d544907fdeb7efdb309310c8b763867d6e0be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41c28efaeff36b255a7d1359399b858eec269bf4551251abc64829e38f818e1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03e6f1aeea6cbdd5934390dd12a4d95c872fbcf7a3d5a560d6df63aa4f7d8c8a"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2e28038ec2be3e45d9f090564b13befc66a4f6830b919a6a30dd36247c976c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61825d586e41805ccdfffa0490b7cb20e4386d4bd28796a6731bf559caf5c510"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8d7552a66f6d03cc0488ea1299ccdd2e7b75ac9217a1d88325c4f472dfa2b61"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["ASCIINEMA_SERVER_URL"] = "https://example.com"
    output = shell_output("#{bin}/asciinema auth 2>&1")
    assert_match "Open the following URL in a web browser to authenticate this CLI", output
  end
end
