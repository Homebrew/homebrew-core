class Observerward < Formula
  desc "Web application and service fingerprint identification tool"
  homepage "https://emo-crab.github.io/observer_ward/"
  url "https://github.com/emo-crab/observer_ward/archive/refs/tags/v2025.4.6.tar.gz"
  sha256 "541cd65c3f325c2fbaa87c875174c4470d8293a6215db5e212be609796e8cb89"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e129ce6364d8a9eb066886b119a83983691679d31fd5293a0cee0fe92dd58ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9883fc2df42873b5ccde235a7b06fa78f9cadfcc526aca9f6f08719ab79b98e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "99653209dce7dd93b9717314a732238e2ea86c82009a7e3898434d423937b792"
    sha256 cellar: :any_skip_relocation, sonoma:        "c836d277e6b7f544e6c038dd06bbafa05a75ee85d62ba50d492da58d07e9a160"
    sha256 cellar: :any_skip_relocation, ventura:       "ad5b83baaf54b11245da36e412b657a3d615a1d0256401e455c6d4270286f031"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08159c8f4bac4f7c9cc60e1eec1e40ec40867c83a2d4ca29278c302aaa98dc4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0433a57de44c745da0612b2023a2ab37d132c4e10a578c42285ab5fb3d60aaff"
  end

  depends_on "rust" => :build

  def install
    rm ".cargo/config.toml" # disable `+crc-static`
    system "cargo", "install", *std_cargo_args(path: "observer_ward")
  end

  test do
    require "utils/linkage"

    system bin/"observer_ward", "-u"
    assert_match "0example", shell_output("#{bin}/observer_ward -t https://www.example.com/")
  end
end
