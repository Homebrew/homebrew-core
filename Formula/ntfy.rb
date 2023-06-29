class Ntfy < Formula
  desc "Send push notifications to your phone or desktop via PUT/POST"
  homepage "https://ntfy.sh/"
  url "https://github.com/binwiederhier/ntfy.git",
      tag:      "v2.6.1",
      revision: "5784b07f149c9a7df706af3925196d39f9ce8d26"
  license any_of: ["Apache-2.0", "GPL-2.0-only"]
  head "https://github.com/binwiederhier/ntfy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4b6eeb544f8fb13471a8c38c9cd861eb99744ad158fe1c0a9345332ed0bff4c7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b6eeb544f8fb13471a8c38c9cd861eb99744ad158fe1c0a9345332ed0bff4c7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4b6eeb544f8fb13471a8c38c9cd861eb99744ad158fe1c0a9345332ed0bff4c7"
    sha256 cellar: :any_skip_relocation, ventura:        "856d87568a9c52991ed923fae2567f607c47871424f0f421fdba1ec60fb07414"
    sha256 cellar: :any_skip_relocation, monterey:       "856d87568a9c52991ed923fae2567f607c47871424f0f421fdba1ec60fb07414"
    sha256 cellar: :any_skip_relocation, big_sur:        "856d87568a9c52991ed923fae2567f607c47871424f0f421fdba1ec60fb07414"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c38fedb6d53571fc9c898bfd254523d2f8a1ff9308627c9f19070ed18c5e8629"
  end

  depends_on "go" => :build

  def install
    system "make", "cli-deps-static-sites"
    ldflags = %W[
      -X main.version=#{version}
      -X main.date=#{time.strftime("%F")}
      -X main.commit=#{Utils.git_head}
      -s
      -w
    ]
    with_env(
      "CGO_ENABLED" => "0",
    ) do
      system "go", "build", *std_go_args(ldflags: ldflags), "-tags", "noserver"
    end
  end

  test do
    require "securerandom"
    random_topic = SecureRandom.hex(6)

    ntfy_in = shell_output("#{bin}/ntfy publish #{random_topic} 'Test message from HomeBrew during build'")
    ohai ntfy_in
    sleep 5
    ntfy_out = shell_output("#{bin}/ntfy subscribe --poll #{random_topic}")
    ohai ntfy_out
    assert_match ntfy_in, ntfy_out
  end
end
