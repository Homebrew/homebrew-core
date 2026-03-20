class Ntfy < Formula
  desc "Send push notifications to your phone or desktop via PUT/POST"
  homepage "https://ntfy.sh/"
  url "https://github.com/binwiederhier/ntfy/archive/refs/tags/v2.19.2.tar.gz"
  sha256 "a4db322d9afa3b8a45ba8e5e44a10c0c43dfc373d41567fb666a50406564c337"
  license any_of: ["Apache-2.0", "GPL-2.0-only"]
  head "https://github.com/binwiederhier/ntfy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7cae09627b58c02e1dc8062659a7a64253784719ffe90ac9afcef925f1dce5c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7cae09627b58c02e1dc8062659a7a64253784719ffe90ac9afcef925f1dce5c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7cae09627b58c02e1dc8062659a7a64253784719ffe90ac9afcef925f1dce5c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "150bae236d2488696f8cd2566ef608565a95e710e39e40cb863060206f981e36"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44fe7bb286b40150ce1aa22af9ad685854cf1fd5ee7220bace07e08af259f436"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f440f0584f9b3cae28f529d1c36d9e1472c1db198ea6dd26349a8ce745620e9"
  end

  depends_on "go" => :build

  def install
    tags = %w[noserver]
    if OS.linux?
      tags = %w[sqlite_omit_load_extension osusergo netgo]
      ENV["CGO_ENABLED"] = "1"
      # Workaround to avoid patchelf corruption when cgo is required
      if Hardware::CPU.arm64?
        ENV["GO_EXTLINK_ENABLED"] = "1"
        ENV.append "GOFLAGS", "-buildmode=pie"
      end
    end

    system "make", "cli-deps-static-sites"
    ldflags = "-s -w -X main.version=#{version} -X main.date=#{time.iso8601} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:, tags:)
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
