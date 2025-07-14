class Ntfy < Formula
  desc "Send push notifications to your phone or desktop via PUT/POST"
  homepage "https://ntfy.sh/"
  url "https://github.com/binwiederhier/ntfy/archive/refs/tags/v2.13.0.tar.gz"
  sha256 "228e521ad682ca3dad23242a266321da2df557646b01fbac08f2d42bd8fc1fa8"
  license any_of: ["Apache-2.0", "GPL-2.0-only"]
  head "https://github.com/binwiederhier/ntfy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88a139128d68294c42b32e57ef254299bd95245f6c86ef0279465853ed8c2bc7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88a139128d68294c42b32e57ef254299bd95245f6c86ef0279465853ed8c2bc7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "88a139128d68294c42b32e57ef254299bd95245f6c86ef0279465853ed8c2bc7"
    sha256 cellar: :any_skip_relocation, sonoma:        "d97145ab8b5951c6346e4a6d8d74359c655928e78f3f317b98f69d9764d006e9"
    sha256 cellar: :any_skip_relocation, ventura:       "d97145ab8b5951c6346e4a6d8d74359c655928e78f3f317b98f69d9764d006e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5979c4e7219f9eb0fc4fe4f1c5c81492c9520c93159ec05cf2c4b546a3278958"
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
