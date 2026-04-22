class Ironclaw < Formula
  desc "Security-first personal AI assistant with WASM sandbox channels"
  homepage "https://github.com/nearai/ironclaw"
  url "https://github.com/nearai/ironclaw/archive/refs/tags/ironclaw-v0.26.0.tar.gz"
  sha256 "329ecbe7aa7e171f639afc822ce24df5551f49e0986036c6fb3d7a29f208fea7"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/nearai/ironclaw.git", branch: "staging"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4e88a94c3861433ff51ca90aba8aad50a2033925c79534dbf325d1c42f6b0e9b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b73f8fb5d7ab89431e6e6e5fce66e1c7b73f070bd365154fba103f9b38f7c5a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8550b71c3db5874c57df5945a57177fbae5faca795d2b50b6deead987562394"
    sha256 cellar: :any_skip_relocation, sonoma:        "18904095253e061ff060e64679ce65961cf87563c7c49aa401ec2487b3978da8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a01fc3db18ece10e3d9c0f73ef4e9775484e3bdac5940a8dbf03ca5115bd1c27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "581474b7c60c23e63be1d5fac98f8b3075d6ca25f9f25685ff598dad88538582"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "python" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  service do
    run [opt_bin/"ironclaw", "run"]
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ironclaw --version")
    assert_match "Missing required configuration: DATABASE_URL", shell_output("#{bin}/ironclaw config list 2>&1", 1)
  end
end
