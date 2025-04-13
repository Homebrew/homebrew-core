class Ntfy < Formula
  desc "Send push notifications to your phone or desktop via PUT/POST"
  homepage "https://ntfy.sh/"
  url "https://github.com/binwiederhier/ntfy/archive/refs/tags/v2.11.0.tar.gz"
  sha256 "56b4c91d53e479e207b8064d894516030f608848c76c6d4eed2d37277d337e71"
  license any_of: ["Apache-2.0", "GPL-2.0-only"]
  head "https://github.com/binwiederhier/ntfy.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "abc17b439d382f5daf76f7dd15581a8dec3e9704d4437a1e6baf9b8619b4ec6a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "abc17b439d382f5daf76f7dd15581a8dec3e9704d4437a1e6baf9b8619b4ec6a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "abc17b439d382f5daf76f7dd15581a8dec3e9704d4437a1e6baf9b8619b4ec6a"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb248dc77fe6a324db6329ba5135236737ea76b14c288e59f886cd2f8987e995"
    sha256 cellar: :any_skip_relocation, ventura:       "cb248dc77fe6a324db6329ba5135236737ea76b14c288e59f886cd2f8987e995"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "903dd3fc5c04f5ac38ac940439a60b28c554b44afabe4550c435e56e07f50b34"
  end

  depends_on "go" => :build

  def install
    system "make", "cli-deps-static-sites"
    ldflags = "-s -w -X main.version=#{version} -X main.date=#{time.iso8601} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:, tags: "noserver")
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
